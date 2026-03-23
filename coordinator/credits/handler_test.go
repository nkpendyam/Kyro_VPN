package credits

import (
	"bytes"
	"context"
	"database/sql"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/gin-gonic/gin"
	_ "modernc.org/sqlite"
)

func setupTestDB(t *testing.T) *sql.DB {
	db, err := sql.Open("sqlite", ":memory:")
	if err != nil {
		t.Fatalf("Failed to open test db: %v", err)
	}

	schema, err := os.ReadFile("../db/schema.sql")
	if err != nil {
		t.Fatalf("Failed to read schema: %v", err)
	}

	if _, err := db.Exec(string(schema)); err != nil {
		t.Fatalf("Failed to execute schema: %v", err)
	}

	return db
}

func TestGetBalance(t *testing.T) {
	db := setupTestDB(t)
	defer db.Close()

	// Seed data
	_, err := db.ExecContext(context.Background(), "INSERT INTO credits (device_id, balance) VALUES ('test-device', 500)")
	if err != nil {
		t.Fatalf("Failed to seed data: %v", err)
	}

	h := NewHandler(db)
	gin.SetMode(gin.TestMode)
	r := gin.Default()
	r.Use(func(c *gin.Context) {
		c.Set("deviceId", "test-device")
		c.Next()
	})
	r.GET("/auth/credits", h.GetBalance)

	req, _ := http.NewRequest("GET", "/auth/credits", nil)

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %v", w.Code)
	}

	var resp map[string]interface{}
	if err := json.Unmarshal(w.Body.Bytes(), &resp); err != nil {
		t.Fatalf("Failed to parse response: %v", err)
	}

	if balance, ok := resp["balance"].(float64); !ok || balance != 500 {
		t.Errorf("Expected balance 500, got %v", resp["balance"])
	}
}

func TestAddTransaction(t *testing.T) {
	db := setupTestDB(t)
	defer db.Close()

	h := NewHandler(db)
	gin.SetMode(gin.TestMode)
	r := gin.Default()
	r.Use(func(c *gin.Context) {
		c.Set("deviceId", "test-device")
		c.Next()
	})
	r.POST("/auth/credits/transaction", h.AddTransaction)

	body := []byte(`{"amount": 100, "reason": "test"}`)
	req, _ := http.NewRequest("POST", "/auth/credits/transaction", bytes.NewBuffer(body))

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %v", w.Code)
	}

	// Verify DB state
	var balance int
	err := db.QueryRowContext(context.Background(), "SELECT balance FROM credits WHERE device_id = 'test-device'").Scan(&balance)
	if err != nil {
		t.Fatalf("Failed to query DB: %v", err)
	}

	if balance != 100 {
		t.Errorf("Expected DB balance 100, got %d", balance)
	}
}
