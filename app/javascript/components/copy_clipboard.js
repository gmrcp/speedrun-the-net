function copyCode() {
  /* Get the text field */

  const lobbyCode = document.getElementById("lobbyCode");

  const cb = navigator.clipboard;

  cb.writeText(lobbyCode.value).then(() => alert('Text copied'));
}

export { copyCode }
