<?php


if (isset($_POST['to'])) {

	$to			= isset($_POST['to']) && !empty($_POST['to']) ? $_POST['to'] : 'noreply@wcie.fr';
	$from		= isset($_POST['from']) && !empty($_POST['from']) ? $_POST['from'] : 'a.devignon@wcie.fr';
	$subject	= isset($_POST['subject']) && !empty($_POST['subject']) ? $_POST['subject'] : 'Test subject';
	$message	= isset($_POST['message']) && !empty($_POST['message']) ? $_POST['message'] : 'This is a test message';
	
	$headers  = 'MIME-Version: 1.0' . "\r\n";
	$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
	$headers .= 'From: ' . $from . "\r\n" .
		'Reply-To: ' . $from . "\r\n" .
		'X-Mailer: PHP/' . phpversion();
	
	
	
	$result = mail($to, $subject, $message, $headers);

}


?>

<html>

	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://bootswatch.com/darkly/bootstrap.min.css" />
		<link rel="stylesheet" href="http://summernote.org/bower_components/summernote/dist/summernote.css" />
		<script src="https://code.jquery.com/jquery-2.2.1.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
		<script src="http://summernote.org/bower_components/summernote/dist/summernote.js"></script>
		
		<style>
			
		</style>
		
	</head>
	<body>
		<div class="container">
			<div class="row">
				<div class="col-md-5">
					<div class="page-header">
					  <h1>Email Sending Form.<br><small>Cought by MailCatcher</small></h1>
					</div>
			
					<?php if(isset($result)): ?>
						<?php if ($result === true): ?>
							<div class="alert alert-success" role="alert">Your email was properly sent. See : <a href="http://127.0.0.1:1080">here</a></div>
						<?php else: ?>
							<div class="alert alert-danger" role="alert">Unable to send your email.</div>
						<?php endif; ?>
					<?php endif; ?>
			
					<form action="mail.php" method="post" enctype="multipart/form-data">
						<div class="form-group">
							<label>From:</label>
							<input type="email" class="form-control" name="from" value placeholder="noreply@wcie.fr" />
						</div>
	
						<div class="form-group">
							<label>To:</label>
							<input type="email" class="form-control" name="to" value placeholder="a.devignon@wcie.fr" />
						</div>
	
						<div class="form-group">
							<label>Subject:</label>
							<input type="text" class="form-control" name="subject" value placeholder="The latest annual report" />
						</div>
	
						<div class="form-group">
							<label>Message:</label>
							<textarea name="message" class="form-control editor"></textarea>
						</div>

						<button type="submit" class="btn btn-default">Submit</button>
					</form>
				</div>
			</div>
		</div>
		
		<script>
			$('.editor').summernote({
				airMode: false
			});
			
		</script>
		
	</body>
</html>