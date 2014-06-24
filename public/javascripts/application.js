$(document).on('ajax:success', '#createTicket', function(e) {
  location.reload();
});
$(document).on('ajax:failure', '#createTicket', function(e, res) {
  var form = $('#new_ticket .modal-body'),
  div = $('<div id="createTicketErrors" class="alert alert-danger"></div>'),
  ul = $('<ul></ul>');
  $.each($.parseJSON(res.responseText).messages, function(i, message) {
    var li = $('<li></li>').text(message);
    ul.append(li);
    if ( $('#createTicketErrors')[0]) {
      $('#createTicketErrors').html(ul);
    } else {
      div.append(ul);
      form.prepend(div);
    }
  });
});
