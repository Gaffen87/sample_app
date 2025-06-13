document.addEventListener("turbo:load", () => {
    const account = document.querySelector("#account");
    account.addEventListener("click", (e) => {
        e.preventDefault();
        const menu = document.querySelector("#dropdown-menu");
        menu.classList.toggle("active");
    })

    const hamburger = document.querySelector("#hamburger");
    hamburger.addEventListener("click", (e) => {
        e.preventDefault();
        const menu = document.querySelector("#navbar-menu");
        menu.classList.toggle("collapse");
    })
})