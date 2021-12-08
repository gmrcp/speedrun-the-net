function copyCode() {
  const lobbyCode = document.getElementById("lobbyCode");
  const container = document.querySelector("#alert-container");

  const cb = navigator.clipboard;

  cb.writeText(lobbyCode.value);
  container.innerHTML =
        `<div class="alert alert-primary alert-dismissible fade show" id='alert-code' role="alert">
          Lobby code copied to clipboard!
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>`
  ;
}


function showCode() {
  function mouseOn() {
    const lobbyCode = document.getElementById("lobbyCode");
    lobbyCode.innerText = lobbyCode.value
  }

  document.getElementById("lobbyCode").addEventListener("mouseover", mouseOn);

  function mouseOut() {
    const lobbyCode = document.getElementById("lobbyCode");
    lobbyCode.innerText = 'INVITE'
  }

  document.getElementById("lobbyCode").addEventListener("mouseleave", mouseOut);
}
export { copyCode, showCode }
