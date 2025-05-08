const mongoose = require('mongoose');
const db = require('../config/db');
const UserModel=require("./user.model");

const { Schema } = mongoose;
const userSchema = new Schema({
    userId: {
        type:Schema.Types.ObjectId,
        ref:UserModel.modelName
    },
    title: {
        type: String,
        required: true,
    },
    desc: {
        type: String,
        required: true,
    }
}, {
    versionKey: false
});
const todoModel = db.model('todo', userSchema);
module.exports = todoModel;
