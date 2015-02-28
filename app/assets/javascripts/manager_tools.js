// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

// $(function() {
//   $("textarea").each( function() {
//     $( this ).text( generateCanned($( this )[0].id) )
//   });
// });
//
// $("input").change(function() {
//   var id = this.id.split("_")[0] + "_" + this.id.split("_")[1];
//   $("#" + id + "_canned").text( generateCanned(id) )
//   console.log(id)
// });
//
// function generateCanned(id) {
//   var id = id.split("_")[0] + "_" + id.split("_")[1];
//   var firstName = id.split("_")[0].capitalize();
//   var month = getLastMonth();
//   var norms = $("#" + id + "_norms").val();
//   var workingShifts = $("#" + id + "_working_shifts").val();
//   var nightShifts = $("#" + id + "_night_shifts").val();
//   var unpaid = $("#" + id + "_unpaid").val();
//   var shiftsDouble = $("#" + id + "_shifts_x_2").val();
//   var overtimesDouble = $("#" + id + "_overtimes_x_2").val();
//   var vacations = $("#" + id + "_vacations").val();
//   var sick = $("#" + id + "_sick").val();
//   var toBePaid = $("#" + id + "_to_be_paid").val().split(" + ")[1];
//
//   var canned = "Hello " + firstName + ",\n\n";
//   canned += "Please find your work report for " + month + ".\n\n"
//   canned += "You had " + workingShifts + " working shifts in " + month + "."
//
//   return canned;
// }