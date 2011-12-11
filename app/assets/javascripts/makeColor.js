// Do Awesome Things With Colors!
function makeColor(index) {
  index = Math.floor(index) || Math.floor(Math.random()*1530);
  function color(i) {
    // Wrap around using modulus 
    i = i % 1530;

    // Calculate the value
    var v;
    if(i < 255)       v = i;
    else if(i < 765)  v = 255;
    else if(i < 1020) v = 255 - (i - 765);
    else              v = 0;

    // Make it a zero-padded value
    v = v.toString(16);
    if(v.length == 1) return "0" + v;
    else              return v;
  }
  function red(i)   { return color(i + 510); }
  function green(i) { return color(i);        }
  function blue(i)  { return color(i + 1020);  }

  return "#" + red(index) + green(index) + blue(index);
}
