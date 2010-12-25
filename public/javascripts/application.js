function removeSubform(elem)
{
  $(elem).closest('.subform').hide('fast').find('input[name$="_destroy"]').val(1);
}

$(function() {
  setTimeout(function() { $(".flash.notice").fadeOut("slow"); }, 5000);
});