# README


rails g scaffold users name:string code:string nickName:string phone:string openid:string gender:boolean avatarUrl:string department:references remark:text 

rails g scaffold departments name:string department:references



rails d scaffold departments
rails d scaffold users