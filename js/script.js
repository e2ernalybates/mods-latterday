document.addEventListener('DOMContentLoaded', function () {
    const burgerMenu = document.querySelector('.burger-menu');
    const navigation = document.querySelector('.navigation');

    burgerMenu.addEventListener('click', function () {
        navigation.classList.toggle('show');
    });
});
