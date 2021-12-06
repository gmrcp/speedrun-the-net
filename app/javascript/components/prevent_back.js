const preventBack = () => {
  window.onpopstate = function (event) {
    alert("This way you'll leave the game!\nAre you sure?");
  };
}

export { preventBack }
