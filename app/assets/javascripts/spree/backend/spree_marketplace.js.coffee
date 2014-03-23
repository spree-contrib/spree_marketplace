#= require spree/backend

$(document).ready ->
  if $('.new_supplier_bank_account').length > 0
    $('.new_supplier_bank_account').submit ->
      if $('#supplier_bank_account_token').val() == ''
        Stripe.bankAccount.createToken({
            country: $('#supplier_bank_account_country_iso').val(),
            routingNumber: $('#supplier_bank_account_routing_number').val(),
            accountNumber: $('#supplier_bank_account_account_number').val(),
        }, stripeBankAccountResponseHandler);
        return false

stripeBankAccountResponseHandler = (status, response) ->
  if response.error
    $('#stripeError').html(response.error.message)
    $('#stripeError').show()
  else
    $('#supplier_bank_account_account_number').prop("disabled" , true);
    $('#supplier_bank_account_routing_number').prop("disabled" , true);
    $('#supplier_bank_account_masked_number').val('xxxxxx' + response['bank_account']['last4'])
    $('#supplier_bank_account_name').val(response['bank_account']['bank_name'])
    $('#supplier_bank_account_token').val(response['id'])
    $('.new_supplier_bank_account').submit()
