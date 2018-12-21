//alert("start");
document.getElementById("button").onclick = myFunction;//{
  //  alert("e");
//};
//alert('erboven');
function myFunction() {
    document.getElementById("button").innerHTML = "het werkt";
    document.getElementById("button").style.backgroundColor = "green";
    document.getElementById("button").style.color = "white";
    document.getElementById("test").innerHTML = "de nieuwe test";
    //alert('Button Clcked');
}
