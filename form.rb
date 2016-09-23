
require 'yaml'

class Form
  attr_accessor :url, :method, :fields
end

class Field
  attr_accessor :name, :validators
end

url1 = Form.new
url1.url ='127.0.0.1'
url1.method ='post'

parm1 = Field.new
parm1.name = 'username'
valist1=Array.new
valist1<<{'name' => 'notempty'}
valist1<<{'name' => 'regex','param' => 'sdaghdjashj'}
parm1.validators = valist1

parm2 = Field.new
parm2.name = 'passwd'
valist2=Array.new
valist2<<{'name' => 'notempty'}
valist2<<{'name' => 'regex','param' => 'hsjadjksad'}
parm2.validators =valist2

valist = Array.new
valist<<parm1
valist<<parm2

url1.fields =Field.new
url1.fields =valist


url2 = Form.new
url2.url ='1.2.3'
url2.method ='get'
url2.fields ='id'

url3=Form.new
url3.url ='1.3.4'
url3.method ='post'
url3.fields ='ip'

nn=Array.new

nn<<url1
nn<<url2
nn<<url3

nn.each do |a|
  puts a.url
end

File.open("url.yml","w+") do |file|
  file.write(nn.to_yaml)
end

# check = Array.new


# #check[input] =
# check[output]=
