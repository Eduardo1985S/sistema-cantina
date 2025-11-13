# 🥐 Sistema Cantina Escolar - Guia Completo para Alunos

## 📚 Bem-vindo!

Este é um sistema completo de gestão de estoque para cantina escolar desenvolvido com **Node.js**, **Express**, **PostgreSQL** e **EJS**. Interface moderna.

---

## 🎯 O que você vai aprender

- ✅ Configurar servidor Node.js com Express
- ✅ Conectar e usar banco de dados PostgreSQL
- ✅ Criar sistema CRUD completo (Create, Read, Update, Delete)
- ✅ Implementar autenticação com sessões
- ✅ Gerenciar estoque com entradas e saídas
- ✅ Criar alertas automáticos de estoque baixo
- ✅ Validar dados e prevenir erros
- ✅ Interface moderna e responsiva

---

## �️ Tecnologias Utilizadas

- **Backend:** Node.js v16+ com Express v5
- **Banco de Dados:** PostgreSQL v12+
- **Template Engine:** EJS (Embedded JavaScript)
- **Sessões:** express-session
- **Design:** CSS3 customizado

---

## �📋 Pré-requisitos

Antes de começar, instale:

### 1. **Node.js** (versão 16 ou superior)
   - Download: https://nodejs.org/
   - Verificar instalação: `node --version`
   - Deve exibir: `v16.x.x` ou superior

### 2. **PostgreSQL** (versão 12 ou superior)
   - Download: https://www.postgresql.org/download/
   - Verificar: `psql --version`
   - **IMPORTANTE:** Anote a senha do usuário `postgres` durante a instalação!

### 3. **Editor de código** (VS Code recomendado)
   - Download: https://code.visualstudio.com/
   - Instale a extensão: PostgreSQL (opcional, mas útil)

---

## 🚀 PASSO 1: Configurar o Banco de Dados

### 1.1 - Iniciar o PostgreSQL

**Windows:**
- Abra o "Services" (Serviços)
- Procure por "postgresql"
- Clique com botão direito → "Start" (Iniciar)

**Ou via SQL Shell (psql):**
```bash
# Abra o psql e conecte com:
# Host: localhost
# Database: postgres
# Port: 5432 (ou 7777 conforme seu caso)
# Username: postgres
# Password: (sua senha)
```

### 1.2 - Criar o Banco de Dados

No psql, execute:

```sql
-- Criar o banco de dados
CREATE DATABASE cantina_db;

-- Conectar ao banco
\c cantina_db

-- Criar tabela de usuários
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar tabela de produtos
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(50),
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    model VARCHAR(100),
    description TEXT,
    unit VARCHAR(20),
    qty INTEGER DEFAULT 0,
    min_stock INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar tabela de movimentações
CREATE TABLE stock_movements (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id),
    type VARCHAR(10) CHECK (type IN ('entrada', 'saida')),
    quantity INTEGER NOT NULL,
    movement_date DATE NOT NULL,
    balance_after INTEGER NOT NULL,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir usuário de teste (senha: admin123)
INSERT INTO users (username, password_hash, name) 
VALUES ('admin', 'admin123', 'Administrador');

-- Inserir produtos de exemplo
INSERT INTO products (sku, name, brand, unit, qty, min_stock) VALUES
('SKU001', 'Suco de Laranja', 'Del Valle', 'Caixa', 50, 20),
('SKU002', 'Pão Francês', 'Padaria Central', 'Unidade', 100, 50),
('SKU003', 'Refrigerante Cola', 'Coca-Cola', 'Lata', 30, 15);

-- Verificar se foi criado
SELECT * FROM users;
SELECT * FROM products;
```

### 1.3 - Verificar a Porta do PostgreSQL

```sql
-- No psql, execute:
SHOW port;
```

**⚠️ ATENÇÃO ESPECIAL:**
- A porta padrão é **5432**
- Alguns sistemas usam **7777**
- **ANOTE A PORTA** - você vai precisar no `server.js`!

### 1.4 - Testar a Conexão

```sql
-- Liste as tabelas criadas:
\dt

-- Deve mostrar: users, products, stock_movements
```

**✅ Se viu as 3 tabelas, está pronto para o próximo passo!**

---

## 🚀 PASSO 2: Configurar o Projeto Node.js

### 2.1 - Abrir o Terminal

1. Abra o **PowerShell** ou **CMD**
2. Navegue até a pasta do projeto:

```powershell
cd C:\Users\professor\Desktop\revisao-tecnica
```

### 2.2 - Inicializar o Projeto Node.js

**Se você está começando do zero**, execute:

```powershell
npm init -y
```

**O que isso faz?**
- Cria o arquivo `package.json` com configurações padrão
- Define o nome, versão e scripts do projeto

**⚠️ Se já existe `package.json`, pule para o passo 2.3**

---

### 2.3 - Instalar as Dependências

Execute os seguintes comandos:

```powershell
npm install express express-session ejs pg
```

**O que isso instala?**
- **express** → Framework para criar o servidor web
- **express-session** → Gerenciamento de sessões (login)
- **ejs** → Template engine para as páginas HTML
- **pg** → Driver para conectar ao PostgreSQL

---

### 2.4 - Instalar Dependências de Desenvolvimento

```powershell
npm install --save-dev nodemon
```

**O que isso faz?**
- **nodemon** → Reinicia o servidor automaticamente ao salvar arquivos
- **--save-dev** → Instala apenas para desenvolvimento (não em produção)

**✅ Após a instalação, você verá:**
- Pasta `node_modules/` criada
- Arquivo `package-lock.json` criado
- Dependências listadas no `package.json`

---

### 2.5 - Configurar o package.json

Abra o arquivo `package.json` na raiz do projeto e verifique se tem o **type "module"** e o **script dev**:

```json
{
  "name": "revisao-tecnica",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "nodemon sistema-cantina/server.js",
    "start": "node sistema-cantina/server.js"
  },
  "dependencies": {
    "ejs": "^3.1.10",
    "express": "^5.1.0",
    "express-session": "^1.18.2",
    "pg": "^8.16.3"
  },
  "devDependencies": {
    "nodemon": "^3.1.11"
  }
}
```

**💡 Agora você pode usar:**
- `npm run dev` → Inicia com nodemon (reinicia automaticamente)
- `npm start` → Inicia normalmente

---

### 2.6 - Configurar a Conexão com o Banco

**🎯 PASSO CRÍTICO - Leia com atenção!**

Abra o arquivo `sistema-cantina/server.js` e localize as linhas 16-22:

```javascript
const pool = new Pool({
  user: "postgres",          // 👈 Usuário do PostgreSQL
  host: "localhost",         // 👈 Servidor local
  database: "cantina_db",    // 👈 Nome do banco criado no PASSO 1
  password: "12345",         // 👈 ⚠️ ALTERE PARA SUA SENHA!
  port: 7777,                // 👈 ⚠️ Use 5432 ou 7777 (ver PASSO 1.3)
});
```

**🔧 AJUSTES OBRIGATÓRIOS:**

1. **password:** Coloque a senha do seu PostgreSQL (definida na instalação)
2. **port:** Use a porta correta (5432 é padrão, 7777 em alguns sistemas)

**Exemplo com senha "minha_senha" e porta 5432:**
```javascript
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "cantina_db",
  password: "minha_senha",   // ✅ Senha alterada
  port: 5432,                // ✅ Porta corrigida
});
```

**⚠️ SE ERRAR A SENHA OU PORTA → ERRO: "ECONNREFUSED"**

---

## 🚀 PASSO 3: Iniciar o Servidor

### 3.1 - Executar o Sistema

**⚠️ IMPORTANTE: Execute os comandos da RAIZ do projeto** (pasta `revisao-tecnica`)

**Opção 1 - Com Nodemon (RECOMENDADO):**

```powershell
# Certifique-se de estar na raiz do projeto:
cd C:\Users\professor\Desktop\revisao-tecnica

# Execute:
npm run dev
```

**Vantagem:** Reinicia automaticamente quando você salvar qualquer arquivo!

**Opção 2 - Com npm start:**

```powershell
# Da raiz do projeto:
npm start
```

**Opção 3 - Com Node direto:**

```powershell
# Entre na pasta:
cd sistema-cantina

# Execute:
node server.js
```

**✅ Você deve ver:**
```
✅ Servidor rodando em http://localhost:3000
```

**❌ Se aparecer erro "ECONNREFUSED":**
- Verifique se o PostgreSQL está rodando
- Confirme a senha e porta no `server.js` (PASSO 2.6)
- Teste a conexão no psql

**❌ Se aparecer erro "scripts desabilitados" (PowerShell):**
```powershell
# Use diretamente:
node sistema-cantina/server.js
```

### 3.2 - Acessar o Sistema

Abra seu navegador e acesse:
```
http://localhost:3000
```

**🎉 Se aparecer a tela de login, PARABÉNS! Está funcionando!**

---

## 🎓 PASSO 4: Usar o Sistema (Tutorial Completo)

### 4.1 - LOGIN

**Credenciais de teste:**
- **Usuário:** `admin`
- **Senha:** `admin123`

1. Digite as credenciais
2. Clique em "Entrar"
3. Você será redirecionado para o **Dashboard**

---

### 4.2 - DASHBOARD (Tela Inicial)

**O que você verá:**
- 📊 Total de produtos cadastrados
- 📈 Total de movimentações
- ⚠️ Lista de produtos com estoque baixo

**Navegação:**
- 📦 Produtos → Cadastro de produtos
- 📋 Estoque → Gestão de estoque
- 🚪 Sair → Fazer logout

---

### 4.3 - CADASTRO DE PRODUTOS (CRUD Completo)

#### 📝 CREATE - Adicionar Produto

1. Clique em **"📦 Produtos"**
2. Preencha o formulário:
   - **SKU:** Código único do produto (ex: PROD001)
   - **Nome:** Nome do produto ⚠️ **OBRIGATÓRIO**
   - **Marca:** Marca/fabricante
   - **Modelo:** Modelo específico
   - **Descrição:** Descrição detalhada
   - **Unidade:** Unidade de medida (Un, Kg, L, Cx, Pct, etc.)
   - **Quantidade:** Estoque inicial (deixe 0 se não tem)
   - **Estoque mínimo:** Alerta quando ficar abaixo (ex: 10)

3. Clique em **"Adicionar Produto"**

**✅ Resultado:** Produto aparece na tabela com status automático

**💡 Exemplo prático:**
- Nome: Suco de Laranja
- Marca: Del Valle
- Unidade: Caixa
- Quantidade: 50
- Estoque mínimo: 20
- **Status:** ✅ OK (pois 50 > 20)

---

#### 📖 READ - Visualizar Produtos

**Na tabela você verá:**
- Nome do produto
- Quantidade atual em estoque
- Estoque mínimo configurado
- **Status automático:**
  - ⚠️ **BAIXO** (vermelho) → Qtd < Estoque mínimo
  - ✅ **OK** (verde) → Qtd >= Estoque mínimo
- Botões de ação (Editar e Excluir)

**🔍 Busca:** Digite no campo de busca para filtrar produtos por nome

---

#### ✏️ UPDATE - Editar Produto

1. Localize o produto na tabela
2. Clique no botão **"✏️ Editar"**
3. Um modal (janela) abrirá com os dados atuais
4. Altere os campos que deseja:
   - Nome do produto
   - Quantidade em estoque
   - Estoque mínimo
5. Clique em **"Salvar"** ou **"Cancelar"**

**✅ Resultado:** Alterações são salvas instantaneamente

**💡 Teste prático de alerta:**
1. Edite um produto
2. Coloque **Quantidade: 5**
3. Coloque **Estoque Mínimo: 10**
4. Salve e vá ao Dashboard
5. **Resultado:** Produto aparecerá na lista de "estoque baixo"! 🎯

---

#### 🗑️ DELETE - Excluir Produto

1. Localize o produto na tabela
2. Clique no botão **"🗑️ Excluir"**
3. Confirme a exclusão na mensagem que aparecer
4. O produto será removido permanentemente

**⚠️ ATENÇÃO:** 
- Esta ação **NÃO** pode ser desfeita!
- Todas as movimentações relacionadas também serão excluídas
- Use com cuidado em produção

---

### 4.4 - GESTÃO DE ESTOQUE

#### 📦 Registrar Entrada de Estoque

**Exemplo prático:** Chegou uma remessa de 50 caixas de suco

1. Clique em **"📋 Estoque"** no menu
2. **Selecione o produto** no dropdown
   - **💡 Ao selecionar, aparecerá:**
     - Estoque atual
     - Estoque mínimo
     - Alerta colorido automático:
       - 🔴 Vermelho: Abaixo do mínimo
       - 🟠 Laranja: No limite mínimo
       - 🟢 Verde: OK
3. Escolha o tipo: **"Entrada"**
4. Digite a **quantidade** recebida (ex: 50)
5. Selecione a **data** da entrada
6. Adicione uma **observação** (opcional): "Compra fornecedor ABC"
7. Clique em **"Registrar"**

**✅ Resultado:**
- Estoque do produto aumenta automaticamente
- Movimentação registrada no histórico
- Dashboard atualizado
- Status recalculado

---

#### 📉 Registrar Saída de Estoque

**Exemplo prático:** Vendeu 20 unidades para um cliente

1. **Selecione o produto**
2. Escolha o tipo: **"Saída"**
3. Digite a **quantidade** vendida/consumida (ex: 20)
4. Selecione a **data**
5. Observação (opcional): "Venda para turma 3º ano"
6. Clique em **"Registrar"**

**✅ Resultado:**
- Estoque diminui automaticamente
- Se ficar abaixo do mínimo → aparece no Dashboard com alerta!
- Histórico atualizado com saldo após a operação

**🛡️ PROTEÇÃO AUTOMÁTICA:**
O sistema **NÃO permite** saídas maiores que o estoque disponível!

**Exemplo:**
- Estoque atual: 15 unidades
- Tentou dar saída de: 20 unidades
- **Resultado:** ❌ Erro com mensagem clara:
  ```
  ⚠️ ERRO: Não há estoque suficiente!
  Estoque atual: 15
  Quantidade solicitada: 20
  ```

---

#### 📊 Visualizar Histórico de Movimentações

**Na tabela você verá as últimas 20 movimentações:**

| Produto | Tipo | Qtd | Data | Saldo | Usuário | Nota |
|---------|------|-----|------|-------|---------|------|
| Suco Laranja | ⬆️ Entrada | 50 | 13/11/2025 | 100 | admin | Compra fornecedor |
| Pão Francês | ⬇️ Saída | 20 | 13/11/2025 | 80 | admin | Venda turma 3º |

**Informações importantes:**
- **Tipo:**
  - ⬆️ **Entrada** (verde) = Produto entrou no estoque
  - ⬇️ **Saída** (vermelho) = Produto saiu do estoque
- **Qtd:** Quantidade movimentada
- **Data:** Quando aconteceu (formato DD/MM/YYYY)
- **Saldo:** Quantidade total APÓS a operação
- **Usuário:** Quem registrou a movimentação
- **Nota:** Observações adicionais

**💡 Dica:** O saldo ajuda a auditar o estoque em qualquer data!

---

## 🎯 EXERCÍCIOS PRÁTICOS

### Exercício 1: Cadastro Completo
1. Cadastre 3 novos produtos
2. Configure estoque mínimo de 10 para cada
3. Coloque quantidade inicial de 5 em um deles
4. Verifique se aparece no Dashboard como "estoque baixo"

### Exercício 2: Movimentação
1. Registre entrada de 20 unidades no produto com estoque baixo
2. Verifique se o alerta sumiu do Dashboard
3. Registre saída de 15 unidades
4. Veja o histórico de movimentações

### Exercício 3: Edição
1. Edite um produto e aumente o estoque mínimo
2. Observe como o status muda
3. Tente excluir um produto e confirme

---

## 🔍 SOLUÇÃO DE PROBLEMAS COMUNS

### ❌ Erro: "ECONNREFUSED" ou "Connection refused"

**Problema:** PostgreSQL não está rodando ou configuração incorreta

**Soluções:**

1. **Verifique se o PostgreSQL está ativo:**
   ```powershell
   # Windows - Abra Services e procure "postgresql"
   # Deve estar com status "Running"
   ```

2. **Teste a conexão manualmente:**
   ```powershell
   # Abra o psql
   # Se conectar = PostgreSQL OK
   # Se não conectar = PostgreSQL não está rodando
   ```

3. **Confirme senha e porta no `server.js`:**
   - Linha 20: `password: "SUA_SENHA_AQUI"`
   - Linha 21: `port: 5432` ou `7777`

4. **Execute no psql:**
   ```sql
   SHOW port;  -- Verifica a porta correta
   ```

---

### ❌ Erro: "relation does not exist"

**Problema:** Tabelas não foram criadas no banco de dados

**Solução:**

1. Conecte ao banco correto:
   ```sql
   \c cantina_db
   ```

2. Verifique se as tabelas existem:
   ```sql
   \dt
   ```

3. Se não aparecer nada, execute novamente os comandos SQL do **PASSO 1.2**

4. Certifique-se de criar as 3 tabelas: `users`, `products`, `stock_movements`

---

### ❌ Erro: "Cannot read properties of undefined" ou "user is undefined"

**Problema:** Usuário de teste não foi inserido no banco

**Solução:**

1. No psql, execute:
   ```sql
   \c cantina_db
   
   -- Verifique se o usuário existe:
   SELECT * FROM users;
   
   -- Se estiver vazio, insira:
   INSERT INTO users (username, password_hash, name) 
   VALUES ('admin', 'admin123', 'Administrador');
   ```

2. Tente fazer login novamente

---

### ❌ Erro: "npm não é reconhecido" ou "node não é reconhecido"

**Problema:** Node.js não está instalado ou não está no PATH

**Solução:**

1. Reinstale o Node.js de https://nodejs.org/
2. **IMPORTANTE:** Marque a opção "Add to PATH" durante instalação
3. Reinicie o terminal após instalar
4. Teste: `node --version` e `npm --version`

---

### ❌ Página em branco ou erro 404

**Problema:** Servidor não está rodando ou arquivos faltando

**Solução:**

1. Verifique se o servidor está rodando:
   - Deve aparecer: `✅ Servidor rodando em http://localhost:3000`

2. Confirme que está na pasta correta:
   ```powershell
   cd C:\Users\professor\Desktop\revisao-tecnica
   npm run dev
   ```

3. Verifique se as pastas existem:
   ```
   sistema-cantina/
   ├── server.js
   ├── public/
   │   └── style.css
   └── views/
       ├── login.ejs
       ├── dashboard.ejs
       ├── cadastro-produto.ejs
       └── gestao-estoque.ejs
   ```

---

### ❌ Erro: "Execução de scripts foi desabilitada"

**Problema:** Política de execução do PowerShell bloqueando npm

**Soluções:**

**Opção 1 - Temporária (mais fácil):**
```powershell
node sistema-cantina/server.js
```

**Opção 2 - Permanente:**
```powershell
# Execute PowerShell como Administrador
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Agora pode usar:
npm run dev
```

---

### ❌ Estoque não atualiza após movimentação

**Problema:** Conversão de tipos ou erro no cálculo

**Solução:**

1. **Já corrigido no código atual!** O sistema agora converte valores para Number
2. Se ainda tiver problema, verifique se no banco os campos `qty` são INTEGER
3. No psql:
   ```sql
   \d products
   -- qty e min_stock devem ser do tipo integer
   ```

---

### ❌ Alerta de estoque baixo não aparece

**Problema:** Comparação incorreta ou min_stock = 0

**Verificações:**

1. **No cadastro de produtos:**
   - Verifique se o `Estoque Mínimo` está preenchido (maior que 0)
   - Exemplo: Qtd = 5, Min = 10 → Deve aparecer como BAIXO

2. **Teste manual:**
   - Edite um produto
   - Coloque Quantidade = 3
   - Coloque Estoque Mínimo = 10
   - Vá ao Dashboard → Deve aparecer o produto!

3. **Se não aparecer, verifique no psql:**
   ```sql
   SELECT name, qty, min_stock 
   FROM products 
   WHERE qty < min_stock AND min_stock > 0;
   ```

---

## 🎨 Design e Interface

### Cores SENAI
- **Vermelho Principal:** #e30613
- **Vermelho Escuro:** #c00510 (hover)
- **Laranja:** #ff6b00 (editar)
- **Verde:** #2e7d32 (OK)
- **Background:** #fafafa (off-white)

### Características Visuais
- ✨ Design moderno e minimalista
- 🎯 Interface limpa com foco no conteúdo
- 📱 Totalmente responsivo (mobile-friendly)
- 🔄 Animações suaves em hover
- 🎨 Feedback visual em todas ações
- ⚡ Modal de edição com overlay
- 🔒 Tela de login centralizada

### Componentes Interativos
- Botões com elevação ao passar o mouse
- Tabelas com highlight de linha
- Inputs com foco destacado
- Badges coloridos de status
- Alertas visuais automáticos

---

## 🚀 Funcionalidades Técnicas Avançadas

### 1. **Validações Implementadas**
- ✅ Previne estoque negativo
- ✅ Valida nome obrigatório no produto
- ✅ Converte valores para Number automaticamente
- ✅ Compara estoque com CAST para INTEGER
- ✅ Ignora produtos com min_stock = 0

### 2. **Segurança**
- ✅ Sessões criptografadas
- ✅ Rotas protegidas com middleware
- ✅ Prepared statements (previne SQL injection)
- ✅ Validação de dados no servidor

### 3. **Performance**
- ✅ CSS otimizado (~330 linhas)
- ✅ Queries indexadas (PRIMARY KEY)
- ✅ Limit de 20 movimentações no histórico
- ✅ ON DELETE CASCADE para integridade

### 4. **UX (Experiência do Usuário)**
- ✅ Alertas visuais em tempo real
- ✅ Confirmação antes de excluir
- ✅ Mensagens de erro claras
- ✅ Status automático (OK/BAIXO)
- ✅ Busca de produtos por nome

---

## 🎓 Conceitos Importantes

### 1. **MVC (Model-View-Controller)**
- **Model:** Tabelas do PostgreSQL (users, products, stock_movements)
- **View:** Arquivos EJS (login.ejs, dashboard.ejs, etc.)
- **Controller:** Rotas no server.js (app.get, app.post)

### 2. **CRUD**
- **C**reate → `INSERT INTO`
- **R**ead → `SELECT`
- **U**pdate → `UPDATE`
- **D**elete → `DELETE`

### 3. **Sessões**
- Mantém usuário logado
- Armazena dados entre requisições
- Protege rotas privadas

### 4. **SQL Injection Protection**
- Uso de prepared statements: `$1, $2, $3`
- Nunca concatenar strings em queries

---

## 🚀 Próximos Passos e Melhorias Sugeridas

### 📈 Nível Intermediário
1. **Categorias de Produtos**
   - Adicionar tabela `categories`
   - Filtrar produtos por categoria
   - Relatório por categoria

2. **Múltiplos Usuários**
   - Sistema de permissões (admin, operador, visualizador)
   - Hash de senhas com bcrypt
   - Auditoria de ações

3. **Busca Avançada**
   - Filtros por data
   - Busca por múltiplos campos
   - Exportar resultados

### 🔥 Nível Avançado
4. **Relatórios e Gráficos**
   - Gráfico de movimentações (Chart.js)
   - Relatório de produtos mais vendidos
   - Exportar PDF/Excel

5. **Fornecedores**
   - Cadastro de fornecedores
   - Relacionar produtos com fornecedores
   - Histórico de compras

6. **Dashboard Avançado**
   - Estatísticas em tempo real
   - Previsão de reposição
   - Valor total em estoque

### 🎨 Front-end
7. **Upload de Imagens**
   - Foto dos produtos
   - Biblioteca Multer
   - Armazenar no servidor ou cloud

8. **API REST**
   - Endpoints JSON
   - Integração com mobile
   - Documentação Swagger

9. **PWA (Progressive Web App)**
   - Funcionar offline
   - Instalável no celular
   - Notificações push

### 🔐 Produção
10. **Deploy**
    - Variáveis de ambiente (.env)
    - HTTPS (SSL/TLS)
    - Deploy em Heroku, Railway ou Vercel
    - Banco PostgreSQL em cloud (ElephantSQL, Supabase)

---

## 📚 Recursos Adicionais

### Documentação Oficial:
- **Node.js:** https://nodejs.org/docs
- **Express:** https://expressjs.com/
- **PostgreSQL:** https://www.postgresql.org/docs/
- **EJS:** https://ejs.co/

### Tutoriais Recomendados:
- Node.js + PostgreSQL: https://node-postgres.com/
- Express Session: https://www.npmjs.com/package/express-session

---

## ❓ Perguntas Frequentes

**Q: Posso usar outro banco de dados?**
A: Sim! MySQL, SQLite ou MongoDB funcionam. Precisa adaptar o código.

**Q: Como adicionar mais usuários?**
A: Execute `INSERT INTO users` no psql com novos dados.

**Q: Como mudar a porta do servidor?**
A: Altere `app.listen(3000` para outra porta no final do server.js.

**Q: O sistema funciona em produção?**
A: Para produção, adicione HTTPS, variáveis de ambiente (.env) e segurança extra.

---

## 👨‍🏫 Suporte

**Dúvidas?** Pergunte ao professor Eduardo Correia

**Bugs encontrados?** Ótimo! Isso faz parte do aprendizado. Tente debugar primeiro:
1. Leia a mensagem de erro
2. Verifique o console do navegador (F12)
3. Veja os logs no terminal
4. Consulte a documentação

---

## 🎉 Parabéns!

Você completou a configuração e aprendeu a usar um **sistema profissional de gestão de estoque**!

### ✅ O que você domina agora:

**Backend:**
- ✅ Servidor Node.js com Express
- ✅ Banco de dados PostgreSQL
- ✅ CRUD completo (Create, Read, Update, Delete)
- ✅ Autenticação com sessões
- ✅ Validações e proteções
- ✅ Queries SQL otimizadas

**Front-end:**
- ✅ Templates dinâmicos com EJS
- ✅ CSS responsivo moderno
- ✅ Interface intuitiva
- ✅ Feedback visual ao usuário

**Lógica de Negócio:**
- ✅ Controle de estoque
- ✅ Alertas automáticos
- ✅ Histórico de movimentações
- ✅ Saldo calculado automaticamente
- ✅ Prevenção de erros

### 🎯 Desafios Práticos

**Para fixar o aprendizado:**

1. **Cadastre 10 produtos** diferentes com dados realistas
2. **Configure alertas** com min_stock variados
3. **Faça 20 movimentações** (entradas e saídas)
4. **Teste todas as validações** (estoque negativo, exclusões, etc.)
5. **Simule um dia real** de uma cantina escolar

### 📚 Continue Aprendendo

**Próximos estudos recomendados:**
- Bcrypt para senha segura
- JWT (JSON Web Tokens) para APIs
- TypeScript para código mais robusto
- React.js para front-end avançado
- Docker para containerização
- CI/CD para deploy automático

### 💬 Feedback e Dúvidas

- **Dúvidas?** Pergunte ao professor
- **Bugs?** Ótimo! Isso faz parte do aprendizado
- **Sugestões?** Implemente e teste!

---

## 📄 Licença e Créditos

**Desenvolvido para fins educacionais - 2025**

**Professor:** Eduardo Correia  
**Instituição:** SENAI  
**Tecnologias:** Node.js, Express, PostgreSQL, EJS  
**Design:** Cores e identidade visual SENAI

---

## 🆘 Suporte Rápido

| Problema | Solução |
|----------|---------|
| Erro ECONNREFUSED | Verificar PostgreSQL rodando e credenciais no server.js |
| Tabelas não existem | Executar comandos SQL do PASSO 1.2 |
| npm não reconhecido | Instalar Node.js e reiniciar terminal |
| Estoque não atualiza | Código já corrigido, verifique tipos no banco |
| Login não funciona | Verificar se usuário 'admin' existe no banco |
| Página 404 | Servidor deve estar rodando (npm run dev) |

---

**🎓 Bons estudos e sucesso no desenvolvimento!** 🚀

*Este projeto demonstra conceitos fundamentais de desenvolvimento full-stack e pode ser expandido para necessidades reais de gestão de estoque.*
