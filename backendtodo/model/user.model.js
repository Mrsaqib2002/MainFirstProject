
const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcryptjs');
const { Schema } = mongoose;

const userSchema = new Schema({
    email: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    password: {
        type: String,
        required: true,
    }
},
 {
    versionKey: false
});

// Add next() here!
userSchema.pre('save', async function (next) {
    try {
        const user = this;
        if (!user.isModified('password')) return next(); // avoid rehashing

        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(user.password, salt);
        user.password = hash;
        next(); // ✅ VERY IMPORTANT!
    } catch (error) {
        next(error); // ❗ Error forward karna zaroori hai
    }
});

// Password compare method
userSchema.methods.comparePassword = async function (userPassword) {
    try {
        return await bcrypt.compare(userPassword, this.password);
    } catch (error) {
        throw error;
    }
};

const UserModel = db.model('User', userSchema);
module.exports = UserModel;
