-- 🗃️ Criar banco
CREATE DATABASE cantina_db;

-- Conectar ao banco
\c cantina_db;

-- 🧑 Usuários
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);

-- 🍞 Produtos
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  sku VARCHAR(50) UNIQUE,
  name VARCHAR(100) NOT NULL,
  brand VARCHAR(100),
  model VARCHAR(100),
  description TEXT,
  unit VARCHAR(20),
  qty INTEGER DEFAULT 0,
  min_stock INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT now()
);

-- 📋 Movimentações de estoque
CREATE TABLE IF NOT EXISTS stock_movements (
  id SERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  user_id INTEGER NOT NULL REFERENCES users(id),
  type VARCHAR(10) NOT NULL CHECK (type IN ('entrada','saida')),
  quantity INTEGER NOT NULL,
  movement_date DATE NOT NULL,
  balance_after INTEGER NOT NULL,
  note TEXT,
  created_at TIMESTAMP DEFAULT now()
);

-- 👩‍💼 Inserir usuários
INSERT INTO users (name, username, password_hash) VALUES
('Admin Teste', 'admin', 'admin123'),
('João da Silva', 'joao.s', 'joao123'),
('Maria Souza', 'maria.s', 'maria123');

-- 🧰 Inserir produtos
INSERT INTO products (sku, name, brand, model, description, unit, qty, min_stock)
VALUES
('REF-COL-350', 'Refrigerante Coca-Cola 350ml', 'Coca-Cola', 'Lata 350ml', 'Bebida gaseificada sabor cola.', 'unidade', 30, 10),
('SALG-QUEI-UN', 'Salgado de Queijo', 'Forno & Sabor', 'Mini Queijo', 'Salgado assado recheado com queijo mussarela.', 'unidade', 50, 10),
('BIS-CHO-90', 'Biscoito Recheado de Chocolate 90g', 'Nestlé', 'Negresco', 'Biscoito crocante com recheio sabor chocolate.', 'unidade', 40, 8);


-- 🧾 Movimentações iniciais
INSERT INTO stock_movements (product_id, user_id, type, quantity, movement_date, balance_after, note)
VALUES
(1,1,'entrada',5, CURRENT_DATE - INTERVAL '10 days', 15, 'Reforço de estoque'),
(2,2,'saida',1, CURRENT_DATE - INTERVAL '5 days', 4, 'Uso interno'),
(3,1,'entrada',3, CURRENT_DATE - INTERVAL '2 days', 11, 'Compra fornecedor');