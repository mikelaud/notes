var regular_joe = "I am global !";

function prison() {
    var prisoner = "I am local !";
}

prison();
console.log(regular_joe);
console.log(prisoner);
