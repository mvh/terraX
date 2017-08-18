Mike's crazy terraform experiments.

So, I'm seeing something odd...

If you check this out, and do a 'terraform apply' (assuming that your
AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables are
set up) after doing a 'terraform init' and a 'terraform get' of course
and then you change the 'us-east-2' in 'main.tf' to 'us-east-1', all
of the stuff that was set up in 'us-east-2' is not cleaned up in any
way as the 'us-east-2' stuff is set up.
