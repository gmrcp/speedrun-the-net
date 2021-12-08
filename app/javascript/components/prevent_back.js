const preventBack = () => {
  window.addEventListener('popstate', function (event) {
    const leavePage = confirm("you want to go ahead ?");
    if (leavePage) {
      history.back();
    } else {
      event.preventDefault();
    }
  });
}


export { preventBack }
