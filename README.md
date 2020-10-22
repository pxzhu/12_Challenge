#### Mackenzie의 12개 웹 앱 만들기 프로젝트
#### Ruby on Rails in MacOS 10.12
##### [Reddit Clone](#Reddit-Clone)

Reddit Clone
- 2020-10-20
>레일즈 프로젝트를 생성합니다.
``` terminal
$ sudo rails new redditclone
```
>프로젝트 폴더로 이동합니다.    
>레일즈 서버를 시작해줍니다.    
``` terminal
$ cd redditclone
$ sudo rails server
```
>테스트를 완료하고 'Ctrl + C'를 이용해 레일즈 서버를 종료합니다.
``` terminal
$ ^C
```
- 2020-10-21
>link 스캐폴드를 생성합니다.
``` terminal
$ sudo rails generate scaffold link title:string url:string
```
>스캐폴드로 만든 데이터베이스를 마이그레이션합니다.
``` terminal
$ sudo rake db:migrate
```
>레일즈 서버를 시작해줍니다.
``` terminal
$ sudo rails server
```
>해당 주소로 접속해줍니다.
```
http://localhost:3000/links
```
>링크를 추가하고 작동하는지 확인합니다.    
>잘 동작하는지 확인하고 서버를 종료합니다.
``` terminal
$ ^C
```
>Gemfile에 다음 항목을 추가하고 저장합니다.
``` gemfile
gem 'devise'
```
>터미널에서 다음 명령어를 실행하여 devise를 설치합니다.
``` terminal
$ sudo bundle install
```
>devise 설치를 완료해줍니다.
``` terminal
$ sudo rails generate devise:install
```
>config/environments/development.rb 파일을 수정합니다.
``` ruby
config.action_mailer.default_url_option = {
  host: 'localhost',
  port: 3000
}
```
>route.rb파일에 경로를 설정합니다. root를 링크 인덱스 페이지로 만듭니다.
``` ruby
root('links#index')
```
>route.rb가 적용이 잘 되었는지 확인합니다.
```
$ sudo rails server
```
>app/views/layouts/application.html.erb에 다음을 추가합니다.
```
<% flash.each do |name, msg| %>
  <%= content_tag(:div, msg, class: "alert alert-#{name}") %>
<% end %>
```
>view와 user를 생성합니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise:User
```
>데이터베이스를 마이그레이션합니다.
``` terminal
$ sudo rake db:migrate
```
>웹 앱이 잘 작동하는지 확인하기 위해 서버를 실행하고 다음으로 이동하세요.
```
$ sudo rails server
http://localhost:3000/users/sign_up
```
>잘 작동한다면 회원가입을 합니다.
```
Email: test@email.com
Password: passwd
```
>서버를 죽이고 사용자가 생성되었는지 확인합니다. 결과는 1입니다.
``` terminal
$ sudo rails c
$ User.count
  => 1
```
>이메일이 잘 표시되는지 확인합니다. 'Ctrl + d'를 이용해 레일즈 콘솔을 종료합니다.
``` terminal
$ @user = User.first
  => email: "test@email.com"
$ ^D
```
>app/views/layouts/application.html.erb 파일에서 로그인 여부에 따라 다른 링크를 제공하는 조건문을 추가합니다.
``` r
<% if user_signed_in? %>
  <ul>
    <li><%= link_to 'Submit link', new_link_path %></li>
    <li><%= link_to 'Account', edit_user_registration_path %></li>
    <li><%= link_to 'Sign out', destroy_user_session_path, :method => :delete %></li>
  </ul>
<% else %>
  <ul>
    <li><%= link_to 'Sign up', new_user_registration_path %></li>
    <li><%= link_to 'Sign in', new_user_session_path %></li>
  </ul>
<% end%>
```
>잘 동작하는지 확인하기 위해 서버를 실행합니다. 로그인과 로그아웃 모두 동작하는지 확인합니다.
``` terminal
$ sudo rails server
```
>등록되지 않은 사용자가 링크를 추가할 수 없도록 app/models/user.rb에 다음 코드를 추가합니다.
``` ruby
has_many :link
```
>app/models/link.rb에 연결을 추가합니다.
``` ruby
belongs_to :user
```
>검사를 위해 레일즈 콘솔로 이동합니다.
``` terminal
$ sudo rails c
```
>첫 번째 링크가 무엇인지 출력합니다.
``` terminal
$ @link = Link.first
  => title: "pxzhu's Github Reddit Clone", url: "https://github.com/pxzhu/12_Challenge/tree/main/re..."
```
>다음과 같이 콘솔에 작성하면 nil을 반환한다.    
>User와 link 간의 연결이 없었으면 쿼리에 대한 오류 메시지가 표시되었을것이다.    
>nil은 오류가 아니다.    
>사용자 column을 데이터베이스에 추가하지 않았기 때문이다.
``` terminal
$ @link.user
  => nil
```
>link 데이터베이스에 User를 추가하기 위해 마이그레이션을 합니다.
``` terminal
$ sudo rails generate migration add_user_id_to_links user_id:integer:index
$ sudo rake db:migrate
```
>추가한 것을 확인합니다.
``` terminal
$ sudo rails c
$ Link.connection
$ Link
  => Link(id: integer, title: string, url: string, created_at: datetime, updated_at: datetime, user_id: integer)
```
>User가 링크를 생성할 때 User id가 해당 링크에 할당되도록 링크 컨트롤러를 업데이트합니다.    
>app/controller/links_controller.rb 안에 메소드를 수정합니다.    
>영상에는 'current_user.links.build'라고 적혀있지만 오류가 발생하여 'current_user.link.build'로 수정하였다.
``` ruby
# before
def new
  @link = Link.new
end
#-------------중략-------------#
def create
  @link = Link.new(link_params)
#-----------이하 생략-----------#
# after
def new
  @link = current_user.link.build
end
#-------------중략-------------#
def create
  @link = current_user.link.build(link_params)
#-----------이하 생략-----------#
```
>작업이 잘 동작하는지 확인합니다.    
>link를 마지막으로 작성한 user id는 1입니다.    
>user id가 1인 사람을 확인합니다.
``` terminal
$ sudo rails c
@link = Link.last
  => Link id: 3, title: "Devise Gem", url: "https://rubygems.org/gems/devise", created_at: "2020-10-21 12:11:49", updated_at: "2020-10-21 12:11:49", user_id: 1
@link.user
  => User id: 1, email: "test@email.com", created_at: "2020-10-21 09:10:45", updated_at: "2020-10-21 09:10:45"
```
>몇 가지 인증을 추가하여 비인증자를 필터링합니다.    
>links_controller.rb에 before_action을 추가합니다.    
``` ruby
before_action :authenticate_user!, except: [:index, :show]
```
>Edit과 Destroy는 로그인을 하지 않으면 동작하지 않는것을 볼 수 있습니다.    
>하지만 다른 사용자가 로그인을 하면 Edit과 Destroy가 동작합니다.
>사용자가 로그인하지 않은 경우 Edit의 경로를 볼 수 없도록 app/views/links/index.html.erb를 수정합니다.
``` r
# before
#-------------생략-------------#
<td><%= link_to 'Show', link %></td>
<td><%= link_to 'Edit', edit_link_path(link) %></td>
<td><%= link_to 'Destroy', link, method: :delete, data: { confirm: 'Are you sure?' } %></td>
#-----------이하 생략-----------#
# after
#-------------생략-------------#
<td><%= link_to 'Show', link %></td>
<% if link.user == current_user %>
  <td><%= link_to 'Edit', edit_link_path(link) %></td>
  <td><%= link_to 'Destroy', link, method: :delete, data: { confirm: 'Are you sure?' } %></td>
<% end %>
#-----------이하 생략-----------#
```
>레일즈 콘솔을 통하여 링크의 생성 User를 알 수 있다.    
>세 번째 링크 생성 User를 1로 바꾸어보자.
``` terminal
$ sudo rails c
$ @link = Link.third
  => Link id: 4, title: "Ruby on Rails", url: "https://rubyonrails.org", created_at: "2020-10-21 12:54:54", updated_at: "2020-10-21 12:54:54", user_id: 2
$ @link.user = User.first
  => User id: 1, email: "test@email.com", created_at: "2020-10-21 09:10:45", updated_at: "2020-10-21 09:10:45"
$ @link.save
$ @link = Link.third
  => Link id: 4, title: "Ruby on Rails", url: "https://rubyonrails.org", created_at: "2020-10-21 12:54:54", updated_at: "2020-10-21 12:57:48", user_id: 1
```
>세 번째 링크 소유자가 1로 바뀐 것을 확인할 수 있다.    
>레일즈 서버를 이용해서 user_id: 2로 로그인 한 뒤에 수정이 가능한지 확인해보자.
>app/views/links/index.html.erb 하단에서 다음 코드를 삭제합니다.
``` r
<%= link_to 'New Link', new_link_path %>
```
- 2020-10-22
>부트스트랩을 추가하기 위하여 Gemfile을 수정하고 설치합니다.
``` gemfile
gem 'bootstrap-sass', '~> 3.4', '>=3.4.1'
```
``` terminal
sudo bundle install
```
>app/assets/stylesheets/application.css의 이름을 app/assets/stylesheets/application.scss로 변경합니다.    
>변경한 파일에 다음 내용을 추가합니다.
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>jquery-rails가 설치가 안되어 있다면 설치하기 위해 Gemfile을 수정하고 다음과 같이 실행합니다.
``` gemfile
gem 'jquery-rails'
```
``` terminal
sudo bundle install
```
>app/views/layouts/application.html.erb파일을 [Mackenzie](https://github.com/mackenziechild/raddit/blob/master/app/views/layouts/application.html.erb)에서 복사 붙여넣기 해줍니다.    
>스타일의 중복 정의를 막기 위해 scaffolds.scss 파일을 삭제합니다.    
>버전 차이로 인해 Pipeline 오류가 발생한다면 아래처럼 수정해주세요.
``` r
# before
<%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
# after
<%= javascript_pack_tag 'application', 'data-turbolinks-track': true %>
```
>정상적으로 작동하는지 확인해봅니다.    
>정상적으로 작동했다면 app/assets/stylesheets/application.scss를 [Mackenzie](https://github.com/mackenziechild/raddit/blob/master/app/assets/stylesheets/application.css.scss)에서 복사 붙여넣기 해줍니다.    
>app/views/links/index.html.erb의 내용을 삭제하고 다음을 추가해줍니다.
``` r
<% @links.each do |link| %>
<div class="link row clearfix">
  <h2>
    <%= link_to link.title, link %><br>
    <small class="author">Submitted <%= time_ago_in_words(link.created_at) %> by <%= link.user.email %></small>
  </h2>
</div>
<% end %>
```
>app/views/links/show.html.erb의 내용을 삭제하고 다음을 추가해줍니다.
``` r
<div class="page-header">
  <h1>
    <a href="<%= @link.url %>"><%= @link.title %></a><br>
    <small>Submitted by <%= @link.user.email %></small>
  </h1>
</div>
<div class="btn-group">
  <%= link_to 'Visit URL', @link.url, class: "btn btn-primary" %>
</div>
<% if @link.user == current_user %>
  <div class="btn-group">
    <%= link_to 'Edit', edit_link_path(@link), class: "btn btn-default" %>
    <%= link_to 'Destroy', @link, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-default" %>
  </div>
<% end %>
```
>추가를 하고 잘 적용이 되었는지 링크를 클릭하여 확인해봅니다.
>잘 동작하는 것을 확인했으면 app/views/links/_form.html.erb의 내용을 수정합니다.
``` r
# before
<div class="field">
  <%= form.label :title %>
  <%= form.text_field :title %>
</div>

<div class="field">
  <%= form.label :url %>
  <%= form.text_field :url %>
</div>

<div class="actions">
  <%= form.submit %>
</div>
# after
<div class="form-group">
  <%= form.label :title %><br>
  <%= form.text_field :title, class: "form-control" %>
</div>

<div class="form-group">
  <%= form.label :url %><br>
  <%= form.text_field :url, class: "form-control" %>
</div>

<div class="actions">
  <%= form.submit "Submit", class: "btn btn-kg btn-primary" %>
</div>
```
>Submit link가 잘 동작하는지 확인합니다.
>app/views/devise/registrations/edit.html.erb를 수정합니다.
``` erb
# before
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>

<% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
  <div>Currently waiting confirmation for: <%= resource.unconfirmed_email %></div>
<% end %>

<div class="field">
  <%= f.label :password %> <i>(leave blank if you don`t want to change it)</i><br />
  <%= f.password_field :password, autocomplete: "new-password" %>
  <% if @minimum_password_length %>
    <br />
    <em><%= @minimum_password_length %> characters minimum</em>
  <% end %>
</div>

<div class="field">
  <%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation, autocomplete: "new-password" %>
</div>

<div class="field">
  <%= f.label :current_password %> <i>(we need your current password to confirm your changes)</i><br />
  <%= f.password_field :current_password, autocomplete: "current-password" %>
</div>

<div class="actions">
  <%= f.submit "Update" %>
</div>
<% end %>

<h3>Cancel my account</h3>

<p>Unhappy? <%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete %></p>

<%= link_to "Back", :back %>

# after
<div class="panel panel-default">
  <div class="panel-body">
    <div class="form-inputs">
      <div class="form-group">
        <%= f.label :email %>
        <%= f.email_field :email, class: "form-control", :autofocus => true %>
      </div>

      <div class="form-group">
        <%= f.label :password %><i>(leave blank if you don't want to change it</i>
        <%= f.password_field :password, class: "form-control", :autocomplete => "off" %>
      </div>

      <div class="form-group">
        <%= f.label :current_password %><i>(we need your current password to confirm your changes</i>
        <%= f.password_field :current_password, class: "form-control" %>
      </div>
    </div>

    <div class="form-group">
      <%= f.submit "Update", class: "btn btn-primary" %>
    </div>
    <% end %>
  </div>

  <div class="panel-footer">
    <h3>Cancel my account</h3>
    <p>Unhappy? <%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete, class: "btn btn-default" %></p>
  </div>
</div>
```
>계정 수정 페이지가 잘 동작하는지 확인합니다.    
>동작이 잘 된다면 app/views/devise/registrations/new.html.erb를 수정합니다.
``` erb
# before
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>

<div class="field">
  <%= f.label :password %>
  <% if @minimum_password_length %>
    <em>(<%= @minimum_password_length %> characters minimum)</em>
  <% end %><br />
  <%= f.password_field :password, autocomplete: "new-password" %>
</div>

<div class="field">
  <%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation, autocomplete: "new-password" %>
</div>

<div class="actions">
  <%= f.submit "Sign up" %>
</div>

# after
<div class="form-group">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, class: "form-control", required: true %>
</div>

<div class="form-group">
  <%= f.label :password %>
  <%= f.password_field :password, class: "form-control", required: true %>
</div>

<div class="form-group">
  <%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation, class: "form-control", required: true %>
</div>

<div class="form-group">
  <%= f.submit "Sign up", class: "btn btn-lg btn primary" %>
</div>
```
>계정 생성 페이지가 잘 동작하는지 확인합니다.
>잘 동작한다면 app/views/devise/sessions/new.html.erb를 다음과 같이 수정합니다.
``` erb
# before
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>

<div class="field">
  <%= f.label :password %><br />
  <%= f.password_field :password, autocomplete: "current-password" %>
</div>

<% if devise_mapping.rememberable? %>
  <div class="field">
    <%= f.check_box :remember_me %>
    <%= f.label :remember_me %>
  </div>
<% end %>

<div class="actions">
  <%= f.submit "Log in" %>
</div>
# after
<div class="form-group">
  <%= f.label :email %>
  <%= f.email_field :email, autofocus: true, class: "form-control", required: false %>
</div>

<div class="form-group">
  <%= f.label :password %>
  <%= f.password_field :password, class: "form-control", required: false %>
</div>

<div class="checkbox">
  <label>
    <%= f.check_box :remember_me, required: false, as: :boolean if devise_mapping.rememberable? %> Remember Me
  </label>
</div>

<div class="form=group">
  <%= f.submit "Log in", class: "btn btn-primary" %>
</div>
```