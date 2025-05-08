const express = require('express');
const bodyParser = require('body-parser');

// Routers
const userRouter = require('./routers/user.router');
const TodoRouter=require('./routers/todo.router');

const app = express();

// Middleware
app.use(bodyParser.json());

// Base route for user-related APIs
app.use('/', userRouter);  // 👈 This makes routes more organized
app.use('/',TodoRouter);
// Global error handler (optional but recommended)
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: err.message });
});

module.exports = app;
