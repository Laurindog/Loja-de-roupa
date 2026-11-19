
const express = require('express');
const dotenv = require('dotenv');
const pool = require('./database');

dotenv.config();

const app = express();

app.use(express.json());

// Rota inicial
app.get('/', (req, res) => {
  res.json({
    mensagem: 'API da Loja de Roupas funcionando!',
    status: 'online'
  });
});

// Rota de teste
app.get('/teste', (req, res) => {
  res.json({
    mensagem: 'Conexão com a API realizada com sucesso!'
  });
});


// Listar todas as compras cadastradas
app.get('/compras', async (req, res) => {
  try {
    const resultado = await pool.query(
      'SELECT * FROM compras ORDER BY id DESC'
    );

    res.json(resultado.rows);
  } catch (erro) {
    console.error('Erro ao buscar compras:', erro.message);
    res.status(500).json({
      mensagem: 'Erro ao buscar compras.'
    });
  }
});

// Cadastrar uma nova compra
app.post('/compras', async (req, res) => {
  try {
    const { numero_venda, valor_compra } = req.body;

    if (!numero_venda || valor_compra == null || Number(valor_compra) <= 0) {
      return res.status(400).json({
        mensagem: 'Informe um número de venda e um valor válido.'
      });
    }

    const resultado = await pool.query(
      `INSERT INTO compras (numero_venda, valor_compra)
      VALUES ($1, $2)
      ON CONFLICT (numero_venda)
      DO UPDATE SET valor_compra = EXCLUDED.valor_compra
      RETURNING *`,
      [numero_venda, valor_compra]
    );

    res.status(201).json(resultado.rows[0]);
  } catch (erro) {
    console.error('Erro ao cadastrar compra:', erro.message);

    res.status(500).json({
      mensagem: 'Erro ao cadastrar compra.'
    });
  }
});


// Criar tabela de compras, caso ainda não exista
async function criarTabela() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS compras (
        id SERIAL PRIMARY KEY,
        numero_venda INTEGER UNIQUE NOT NULL,
        valor_compra DECIMAL(10, 2) NOT NULL,
        criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    console.log('Tabela compras criada ou já existente!');
  } catch (erro) {
    console.error('Erro ao criar tabela:', erro.message);
  }
}

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', async () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  await criarTabela();
});
