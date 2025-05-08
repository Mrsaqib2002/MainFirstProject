const TodoModel=require("../model/todo.model");
class TodoServices{

    static async createtodo(userId,title,desc){

        const createtodo =new TodoModel({userId,title,desc});

        return createtodo.save();
            }

      static async gettododata(userId){

        const tododata =await TodoModel.find({userId})
        
        return tododata;;
                    }
       static async deletetodo(id){

       const deleted=await TodoModel.findOneAndDelete({_id:id})

                        
        return deleted;
                                    }             
}

module.exports=TodoServices;