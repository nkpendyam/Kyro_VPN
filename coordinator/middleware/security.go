package middleware

import (
	"net/http"
	"sync"

	"github.com/gin-gonic/gin"
	"golang.org/x/time/rate"
)

var (
	visitors = make(map[string]*rate.Limiter)
	mu       sync.Mutex
)

// getVisitor retrieves or creates a rate limiter for an IP
func getVisitor(ip string) *rate.Limiter {
	mu.Lock()
	defer mu.Unlock()

	limiter, exists := visitors[ip]
	if !exists {
		// 5 requests per second, burst of 10
		limiter = rate.NewLimiter(rate.Limit(5), 10)
		visitors[ip] = limiter
	}
	return limiter
}

// RateLimit middleware prevents abuse by limiting requests per IP
func RateLimit() gin.HandlerFunc {
	return func(c *gin.Context) {
		ip := c.ClientIP()
		limiter := getVisitor(ip)

		if !limiter.Allow() {
			c.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{
				"error": "too many requests",
			})
			return
		}
		c.Next()
	}
}

// DeviceAuth middleware validates a device_id header
func DeviceAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		deviceId := c.GetHeader("X-Device-Id")
		if deviceId == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error": "missing device ID",
			})
			return
		}
		
		// Pass deviceId to context for handlers
		c.Set("deviceId", deviceId)
		c.Next()
	}
}
