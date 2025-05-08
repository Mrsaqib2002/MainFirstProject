const router =require('express').Router();
const todocontroller=require('../controller/todo.controller');
router.post('/todo',todocontroller.cresteTodo);
router.get('/',todocontroller.getusertodo);

router.post('/',todocontroller.deletetodo);

module.exports=router;