import { data } from "jquery";

async function preventReload() {
  window.onbeforeunload = () => {
    location.replace('http://localhost:3000/');
    location.reload(true);
  }
}

export { preventReload }
