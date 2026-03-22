# Kyro VPN API Specification

This document defines the API contracts for the Kyro VPN Coordinator.

**Base URL:** `https://kyrovpn.is-a.dev`

---

## 1. Node Discovery

### Get Best Node
Returns the optimal node for the user based on bandwidth, latency, and uptime.

*   **URL:** `/nodes/best`
*   **Method:** `GET`
*   **Auth Required:** No
*   **Success Response:**
    *   **Code:** 200
    *   **Content:**
        ```json
        {
          "node_id": "uuid-string",
          "public_key": "wg-public-key",
          "endpoint": "address.portmap.io:12345",
          "city": "Bangalore",
          "country_code": "IN"
        }
        ```
*   **Error Response:**
    *   **Code:** 503 Service Unavailable (No nodes online)

---

## 2. Node Management (Internal)

### Register Node
Used by the `node-daemon` to register a new exit node.

*   **URL:** `/nodes/register`
*   **Method:** `POST`
*   **Auth Required:** No (Node generates its own identity)
*   **Data Params:**
    ```json
    {
      "public_key": "wg-public-key",
      "playit_address": "address.portmap.io:12345",
      "city": "Bangalore",
      "country_code": "IN"
    }
    ```
*   **Success Response:**
    *   **Code:** 201 Created
    *   **Content:** `{ "node_id": "uuid-string" }`

### Heartbeat
Nodes must send a heartbeat every 60 seconds to remain "online".

*   **URL:** `/nodes/heartbeat`
*   **Method:** `POST`
*   **Auth Required:** No (Uses node_id)
*   **Data Params:**
    ```json
    {
      "node_id": "uuid-string"
    }
    ```
*   **Success Response:**
    *   **Code:** 200 OK

---

## 3. Credits & Authentication

### Get Balance
Returns the current credit balance for the device.

*   **URL:** `/auth/credits`
*   **Method:** `GET`
*   **Headers:** `X-Device-Id: <uuid>`
*   **Success Response:**
    *   **Code:** 200 OK
    *   **Content:**
        ```json
        {
          "balance": 500,
          "total_earned": 1200,
          "total_spent": 700
        }
        ```

### Add Transaction
Records a credit earn or spend event.

*   **URL:** `/auth/credits/transaction`
*   **Method:** `POST`
*   **Headers:** `X-Device-Id: <uuid>`
*   **Data Params:**
    ```json
    {
      "amount": 100,
      "reason": "Contribution"
    }
    ```
*   **Success Response:**
    *   **Code:** 200 OK
