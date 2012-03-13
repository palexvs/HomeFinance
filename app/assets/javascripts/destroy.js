$(document).ready(function(){
	$('.btn[data-method="delete"]').bind('ajax:success', function(evt, data, status, xhr){
		newAlert('success', 'Transaction was successfully delete.');
		$('tr#transaction_' + data['id']).fadeOut();
	});
})