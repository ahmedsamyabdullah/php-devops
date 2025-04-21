<?php	
header("Cache-Control: no-cache, no-store, must-revalidate"); // HTTP 1.1.
header("Pragma: no-cache"); // HTTP 1.0.
header("Expires: 0"); // Proxies.
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>PHP DevOps</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="style.css">

    </head>
    <body>
        <div class="container">
            <H1 class="text-center" >Hello & Welcome</H1>
            <h2>Ahmed Samy </h2>
            <p>You Can go to the project repo on github </p> <a href="https://github.com/ahmedsamyabdullah/php-devops" class="btn btn-primary">Github Repo</a>
            <H3> Hello - S2Image </H1>
            <img src="/a-abtesting.png">
            <div>
            <?php 
            echo "My Pod IP is : ".$_SERVER['SERVER_ADDR'] ;
            ?>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
