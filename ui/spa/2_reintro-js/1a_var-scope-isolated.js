var non_prisoner = "I am global and free !";

function prison() {
    var prisoner = "I am isolated !";
}

prison();

// I am global and free !
console.log(non_prisoner);

// Error
console.log(prisoner);
