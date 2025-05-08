 const UserModel=require('../model/user.model');
 const jwt = require('jsonwebtoken');  // ✅ Add this line at the top
 const bcrypt = require('bcryptjs');
 require('dotenv').config();
// class UserService{
//     static async register(email,password){
// try {
//     const createUser= new UserModel({email,password});
//     return await createUser.save();

// } catch (error) {
//     throw error;
// }
//     }
//     static async cheackuser(email){
//         try {
//             return await UserModel.findOne({email});
//         } catch (error) {
//             throw error;
//         }
//     }

// static async genrateToken(tokenData, secretKey, expiresIn) {
//     return jwt.sign(tokenData, secretKey, { expiresIn: expiresIn }); // Use expiresIn directly
// }

// }

// module.exports=UserService;

class UserService {
    static async register(email, password) {
        try {
            // Hash password before saving
            const hashedPassword = await bcrypt.hash(password, 10);
            const createUser = new UserModel({
                email,
                password: hashedPassword
            });
            return await createUser.save();
        } catch (error) {
            console.error('Registration error:', error);
            throw new Error('Failed to register user');
        }
    }

    static async checkUser(email) { // ✅ Fixed method name
        try {
            return await UserModel.findOne({ email });
        } catch (error) {
            console.error('Find user error:', error);
            throw new Error('Failed to find user');
        }
    }

    static async generateToken(tokenData) {
        try {
            if (!process.env.JWT_SECRET) {
                throw new Error('JWT secret not configured');
            }
            return jwt.sign(
                tokenData,
                process.env.JWT_SECRET, // Directly use from .env
                { expiresIn: '1h' } // Fixed expiry
            );
        } catch (error) {
            console.error('Token generation error:', error);
            throw new Error('Failed to generate token');
        }
    }
}

module.exports = UserService;