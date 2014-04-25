$(function() {
  function stripeResponseHandler(status,response) {
    if(response.error) {
      $('#stripe_error').text(response.error.message);
      $('#stripe_error').addClass('alert alert-error');
    } else {
      $('#stripe_card_token').val(response.id);
      $('#new_stripe_customer')[0].submit();
    }
  }
  $('#new_stripe_customer').live('submit', function() {
    Stripe.createToken({number: $('#card_number').val(), cvc: $('#card_code').val(), exp_month: $('#card_month').val(), exp_year: $('#card_year').val()}, stripeResponseHandler);
    return false;
  });
});
