db.users.insertMany([
  { name: "Juan Pérez", age: 25, email: "juan@mail.com" },
  { name: "Ana Gómez", age: 30, email: "ana@mail.com" },
  { name: "Pedro Ramírez", age: 22, email: "pedro@mail.com" },
  { name: "Luisa Martínez", age: 28, email: "luisa@mail.com" }
]);


db.tickets.insertMany([
  { ticket_id: 1, user_id: 1, price: 150 },
  { ticket_id: 2, user_id: 2, price: 80 },
  { ticket_id: 3, user_id: 3, price: 50 },
  { ticket_id: 4, user_id: 4, price: 150 }
]);

// Traer tickets con nombre de usuario
db.tickets.aggregate([
  {
    $lookup: {
      from: "users",
      localField: "user_id",
      foreignField: "user_id",
      as: "user_info"
    }
  },
  { $unwind: "$user_info" } // para desanidar el array
]);

// Consulta ejemplo
db.users.find({ age: { $gt: 25 } });


// mayor que
db.users.find({ age: { $gt: 25 } });

// menores o igual
db.users.find({ age: { $lte: 28 } });


// entre 22 hasta 28
db.users.find({ age: { $gte: 22, $lte: 28 } });



// Usuarios cuyo nombre sea Juan o Pedro
db.users.find({ name: { $in: ["Juan Pérez", "Pedro Ramírez"] } });

// Usuarios que NO sean Ana
db.users.find({ name: { $nin: ["Ana Gómez"] } });



// Usuarios mayores de 25 O con nombre Ana
db.users.find({ $or: [ { age: { $gt: 25 } }, { name: "Ana Gómez" } ] });

// Usuarios mayores de 22 Y menores de 30
db.users.find({ $and: [ { age: { $gt: 22 } }, { age: { $lt: 30 } } ] });




// Ordenar por edad ascendente
db.users.find().sort({ age: 1 });

// Ordenar por edad descendente
db.users.find().sort({ age: -1 });





// Traer los primeros 2 usuarios
db.users.find().limit(2);

// Saltar 1 y traer 2 siguientes
db.users.find().skip(1).limit(2);






// Total de edad de todos los usuarios
db.users.aggregate([
  { $group: { _id: null, total_edad: { $sum: "$age" } } }
]);

// Promedio de edad
db.users.aggregate([
  { $group: { _id: null, promedio_edad: { $avg: "$age" } } }
]);



db.users.insertMany([
  { user_id: 1, name: "Juan Pérez", age: 25, email: "juan@mail.com" },
  { user_id: 2, name: "Ana Gómez", age: 30, email: "ana@mail.com" }
]);

db.tickets.insertMany([
  { ticket_id: 1, user_id: 1, price: 150 },
  { ticket_id: 2, user_id: 2, price: 80 }
]);

// Consulta ejemplo
db.users.find({ age: { $gt: 25 } });





