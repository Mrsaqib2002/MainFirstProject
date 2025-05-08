const TodoServices=require('../services/todo.server');
exports.cresteTodo=async(req,res,next)=>{
    try {
        const {userId,title,desc}=req.body;
        let todo=await TodoServices.createtodo(userId,title,desc);
   res.status(201).json({status:true,success:todo});
    } catch (error) {
        next(error);
    }
}
exports.getusertodo=async(req,res,next)=>{
    try {
        const {userId,}=req.body;

        let todo=await TodoServices.gettododata(userId);
   
        res.status(201).json({status:true,success:todo});
    } catch (error) {
        next(error);
    }
}
exports.deletetodo=async(req,res,next)=>{
    try {
        const {id,}=req.body;

        let deleted=await TodoServices.deletetodo(Id);
   
        res.status(201).json({status:true,success:deleted});
    } catch (error) {
        next(error);
    }
}