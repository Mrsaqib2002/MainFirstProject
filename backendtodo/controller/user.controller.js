const UserService = require('../services/user.services');

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        // Ensure email and password are provided
        if (!email || !password) {
            return res.status(400).json({ error: "Email and password are required" });
        }

        const user = await UserService.register(email, password);
        res.status(201).json({ status: 201, success: "User registered successfully" });
    } catch (error) {
        next(error); // Pass error to error handler middleware
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        
        // Validation
        if (!email || !password) {
            return res.status(400).json({ 
                success: false,
                message: "Email and password are required" 
            });
        }

        // Check user exists
        const user = await UserService.checkUser(email);
        if (!user) {
            return res.status(404).json({ 
                success: false,
                message: 'User not found' 
            });
        }

        // Verify password
        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(401).json({ 
                success: false,
                message: "Invalid credentials" 
            });
        }

        // Generate token
        const tokenData = { 
            _id: user._id, 
            email: user.email 
        };
        const token = await UserService.generateToken(
            tokenData, 
            process.env.JWT_SECRET, 
            process.env.JWT_EXPIRY || '1h'
        );

        // Successful response
        return res.status(200).json({
            success: true,
            message: "Login successful",
            token,
            user: {
                id: user._id,
                email: user.email,
                // include other necessary user fields
            }
        });

    } catch (error) {
        console.error('Login error:', error);
        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
};