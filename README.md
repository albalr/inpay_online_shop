# Inpay Online Shop
A simple online shop built with **Ruby on Rails**, powered by **Docker**, and offering both a styled frontend and a RESTful JSON API.

---

## Features

- **Product Catalog:** Browse all available products.
- **Order Placement:** Select quantities and place orders for one or more products.
- **Admin Access:** Create and delete (soft delete) products via the web UI (Admin Access button).
- **API Documentation:** Interactive Swagger UI at `/api-docs`.
- **Consistent Error Handling:** All API errors return clear JSON responses.
- **Fully Dockerized:** Easy to run locally with Docker and Docker Compose.

---

## Tech Stack

- **Backend:** Ruby on Rails 7
- **Database:** PostgreSQL
- **Frontend:** ERB templates, custom CSS and JavaScript
- **API Docs:** Swagger (via rswag)
- **Containerization:** Docker, Docker Compose

---

## Getting Started

### 1. Clone the repository

```bash
git clone <repo-url>
cd inpay_shop
```

### 2. Start the application with Docker Compose

```bash
docker compose up
```

This will build the app and start both the Rails server and the PostgreSQL database.

### 3. Set up the database

In a new terminal, run:

```bash
docker compose run web rails db:create db:migrate
```

### 4. Access the application

- **Shop UI:** [http://localhost:3000/shop](http://localhost:3000/shop)
- **API Docs:** [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

---

## Overview

- Visit the shop at: http://localhost:3000
- Add products to the cart and place orders
- Products are auto-archived when stock reaches zero
- Enable admin mode by appending `?admin=true` to the URL or clicking the "Admin Access" button in the footer, which enables admin features like product creation and deletion.


---

## Cleanup & Reset

**Stop containers:**

```bash
docker compose down
```

**Reset database:**

```bash
docker compose run web rails db:drop db:create db:migrate
```

---

## API Overview

- **List Products:** `GET /products`
- **Show Product:** `GET /products/:id`
- **Create Product:** `POST /products`
- **Update Product:** `PUT /products/:id`
- **Delete Product:** `DELETE /products/:id`

- **List Orders:** `GET /orders`
- **Show Order:** `GET /orders/:id`
- **Create Order:** `POST /orders`

See full details and try out endpoints at `/api-docs`.

---

## Project Structure

```
app/
├── controllers/   # Application and API controllers
├── models/        # Models
├── views/         # HTML views (shop and orders)
config/
└── routes.rb      # Routes definition
```

---

## Author

Alba López Ruiz
