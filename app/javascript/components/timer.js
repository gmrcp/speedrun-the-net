const displayTime = async () => {
  const timer = document.getElementById('timer')
  const startTime = timer.dataset.startTime
  for (let i = 0; i < 100000; i++) {
    formatTime(startTime, timer);
    await new Promise(r => setTimeout(r, 1000));
  };
};

const finishTime = () => {
  const timer = document.getElementById('timer')
  const startTime = timer.dataset.startTime
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
