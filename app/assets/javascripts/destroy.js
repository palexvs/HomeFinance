$(document).ready(function(){
	$('.transactions-list').on('ajax:success', 'a[data-method="delete"]', function(evt, data){
		newAlert('success', 'Transaction was successfully delete.');
		$('tr#transaction_' + data['id']).fadeOut(500, function() { $(this).remove() } );
	});
})