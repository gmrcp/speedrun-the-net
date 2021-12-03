const displayTime = async () => {
  const startTime = document.getElementById('start-time').innerText
  const timer = document.getElementById('timer')
  for (let i = 0; i < 100000; i++) {
    formatTime(startTime, timer);
    await new Promise(r => setTimeout(r, 1000));
  };
};

const finishTime = () => {
  const startTime = document.getElementById('start-time').innerText
  const modalDisplay = document.getElementById('finish')
  formatTime(startTime, modalDisplay)
}

const formatTime = (startTime, element) => {
  const total = Date.now() - Date.parse(startTime);
  // let milliseconds = total % 1000;
  let seconds = Math.floor(total / 1000 % 60);
  let minutes = Math.floor(seconds / 60);
  // milliseconds = milliseconds.toString().padStart(3, "0");
  seconds = seconds.toString().padStart(2, "0");
  minutes = minutes.toString().padStart(2, "0");
  element.innerText= `${minutes}:${seconds}`;
}

export { displayTime, finishTime }
