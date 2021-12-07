function copyCode() {
  /* Get the text field */

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

export { copyCode }
