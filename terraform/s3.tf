resource "aws_s3_bucket" "assets" {
  bucket = "${var.product}-assets"
}

resource "aws_s3_bucket_acl" "assets" {
  bucket = aws_s3_bucket.assets.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "assets" {  
  bucket = aws_s3_bucket.assets.id   
  policy = <<POLICY
  {    
      "Version": "2012-10-17",    
      "Statement": [        
        {            
            "Sid": "PublicReadGetObject",            
            "Effect": "Allow",            
            "Principal": "*",            
            "Action": [                
              "s3:GetObject"            
            ],            
            "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.assets.id}/*"            
            ]        
        }    
      ]
  }
  POLICY
}