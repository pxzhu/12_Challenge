### Mackenzie의 12개 웹 앱 만들기 프로젝트
### Ruby on Rails in MacOS 10.12

## 목차

Chapter 01. [Reddit Clone](#reddit-clone)    
Chapter 02. [Blog](#blog)    
Chapter 03. [Recipe Box](#recipe-box)    
Chapter 04. [Pinterest Clone](#pinterest-clone)    
Chapter 05. [Movie Review](#moview-review)    
Chapter 06. [Todo](#Todo)    
Chapter 07. [Jobs Board](#jobs-board)    
Chapter 08. [Workout Log](#workout-log)    
Chapter 09. [Wikipedia Clone](#wikipedia-clone)    
Chapter 10. [Forum](#forum)    
Chapter 11. [NoteNote](#notenote)    
Chapter 12. [Muse](#muse)

---

## Reddit Clone
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
``` rb
config.action_mailer.default_url_option = {
  host: 'localhost',
  port: 3000
}
```
>route.rb파일에 경로를 설정합니다. root를 링크 인덱스 페이지로 만듭니다.
``` rb
root('links#index')
```
>route.rb가 적용이 잘 되었는지 확인합니다.
```
$ sudo rails server
```
>app/views/layouts/application.html.erb에 다음을 추가합니다.
``` erb
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
``` erb
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
``` rb
has_many :link
```
>app/models/link.rb에 연결을 추가합니다.
``` rb
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
>app/controller/links_controller.rb 안에 드를 수정합니다.    
>영상에는 'current_user.links.build'라고 적혀있지만 오류가 발생하여 'current_user.link.build'로 수정하였다.
``` rb
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
``` rb
before_action :authenticate_user!, except: [:index, :show]
```
>Edit과 Destroy는 로그인을 하지 않으면 동작하지 않는것을 볼 수 있습니다.    
>하지만 다른 사용자가 로그인을 하면 Edit과 Destroy가 동작합니다.
>사용자가 로그인하지 않은 경우 Edit의 경로를 볼 수 없도록 app/views/links/index.html.erb를 수정합니다.
``` erb
<!-- before -->
<!-- 생략 -->
<td><%= link_to 'Show', link %></td>
<td><%= link_to 'Edit', edit_link_path(link) %></td>
<td><%= link_to 'Destroy', link, method: :delete, data: { confirm: 'Are you sure?' } %></td>
<!-- 이하 생략 -->
<!-- after -->
<!-- 생략 -->
<td><%= link_to 'Show', link %></td>
<% if link.user == current_user %>
  <td><%= link_to 'Edit', edit_link_path(link) %></td>
  <td><%= link_to 'Destroy', link, method: :delete, data: { confirm: 'Are you sure?' } %></td>
<% end %>
<!-- 이하 생략 -->
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
``` erb
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
``` erb
<!-- before -->
<%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
<!-- after -->
<%= javascript_pack_tag 'application', 'data-turbolinks-track': true %>
```
>정상적으로 작동하는지 확인해봅니다.    
>정상적으로 작동했다면 app/assets/stylesheets/application.scss를 [Mackenzie](https://github.com/mackenziechild/raddit/blob/master/app/assets/stylesheets/application.css.scss)에서 복사 붙여넣기 해줍니다.    
>app/views/links/index.html.erb의 내용을 삭제하고 다음을 추가해줍니다.
``` erb
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
``` erb
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
``` erb
<!-- before -->
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
<!-- after -->
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
<!-- before -->
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

<!-- after -->
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
<!-- before -->
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

<!-- after -->
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
<!-- before -->
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
<!-- after -->
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
>투표 시스템을 만들기 위해 Gemfile을 수정하고 설치해줍니다.
``` gemfile
gem 'acts_as_votable', '~> 0.12.1'
```
``` terminal
sudo gem install acts_as_votable
```
>투표를 저장할 테이블을 만들고 마이그레이션합니다.
``` terminal
sudo rails generate acts_as_votable:migration
sudo rake db:migrate
```
>app/models/link.rb에 다음 항목을 추가합니다.
``` rb
acts_as_votable
```
>잘 동작하는지 확인하기 위해 레일즈 콘솔을 이용하여 확인합니다.
``` terminal
$ sudo rails c
$ @link = Link.first
$ @user = User.first
$ @link.votes_for.size
$ @link.save
```
>투표를 볼 수 있도록 app/config/route.rb로 이동하여 다음을 추가합니다.
``` rb
# before
resources :links
# after
resources :links do
  member do
    put "like", to: "links#upvote"
    put "dislike", to: "links#downvote"
  end
end
```
>app/controller/links_controllers.rb에서 다음 메서드를 추가합니다.
``` rb
# upvote
def upvote
  @link = Link.find(params[:id])
  @link.upvote_by current_user
  redirect_to fallback_location: '/'
end
# downvote
def downvote
  @link = Link.find(params[:id])
  @link.downvote_by current_user
  redirect_to fallback_location: '/'
end
```
>app/views/links/index.html.erb에서 Upvote와 Downvote 버튼을 추가합니다.
``` erb
<!-- before -->
<!-- 생략 -->
  </h2>
</div>
<% end %>
<!-- after -->
<!-- 생략 -->
  </h2>
  <div class="btn-group">
    <a class="btn btn-default btn-sm" href="<%= link.url %>">Visit Link</a>
    <%= link_to like_link_path(link), method: :put, class: "btn btn-default btn-sm" do %>
      <span class="glyphicon glyphicon-chevron-up"></span>
      Upvote
      <%= link.get_upvotes.size %>
    <% end %>
    <%= link_to dislike_link_path(link), method: :put, class: "btn btn-default btn-sm" do %>
      <span class="glyphicon glyphicon-chevron-down"></span>
      Downvote
      <%= link.get_downvotes.size %>
    <% end %>
  </div>
</div>
<% end %>
```
>app/views/links/show.html.erb에 Upvote와 Downvote 기능을 추가하기 위해 다음을 추가합니다.
``` erb
<div class="btn-group pull-right">
  <%= link_to like_link_path(@link), method: :put, class: "btn btn-default btn-sm" do %>
    <span class="glyphicon glyphicon-chevron-up"></span>
    Upvote
    <%= @link.get_upvotes.size %>
  <% end %>
  <%= link_to dislike_link_path(@link), method: :put, class: "btn btn-default btn-sm" do %>
    <span class="glyphicon glyphicon-chevron-up"></span>
    Downvote
    <%= @link.get_downvotes.size %>
  <% end %>
</div>
```
- 2020-10-23
>댓글 기능을 추가하기 위해 아래와 같이 스카폴드를 수행하고 마이그레이션을 해줍니다.    
>정상적으로 동작하는지 서버를 실행해서 확인해봅니다.
``` terminal
$ sudo rails generate scaffold Comment link_id:integer:index body:text user:references
$ sudo rake db:migrate
```
>comment를 사용하기 위한 simple_form을 설치하기 위해 Gemfile을 수정하고 설치해줍니다.
``` gemfile
gem 'simple_form'
```
``` terminal
sudo bundle install
```
>app/models/comment.rb 파일에 다음을 추가해줍니다.
``` rb
belongs_to :link
```
>app/models/link.rb 파일에 다음을 추가해줍니다.
``` rb
has_many :comments
```
>config/routes.rb 파일을 다음과 같이 수정해줍니다.
``` rb
# before
resources :links do
  member do
    put "like", to: "links#upvote"
    put "dislike", to: "links#downvote"
  end
end
# after
resources :links do
  member do
    put "like", to: "links#upvote"
    put "dislike", to: "links#downvote"
  end
  resources :comments
end
```
>create에 메서드를 추가하기 위해 app/controllers/comments_controller.rb 파일을 수정해줍니다.
``` rb
# before
@comment = Comment.new(comment_params)
# after
@link = Link.find(params[:link_id])
@comment = @link.comments.new(comment_params)
@comment.user = current_user
```
>app/views/links/show.html.erb 파일 하단에 다음을 추가해줍니다.
``` erb
<h3 class="comments_title">
  <%= @link.comments.count %> comments
</h3>

<div id="comments">
  <%= render :partial => @link.comments %>
</div>
<%= simple_form_for [@link, Comment.new] do |f| %>
  <div class="field">
    <%= f.text_area :body, class: "form-control" %>
  </div>
  <br>
  <%= f.submit "Add Comment", class: "btn btn-primary" %>
<% end %>
```
>렌더링을 위한 페이지를 만들기 위해 app/views/comments에 다음을 포함한 _comment.html.erb를 만들어줍니다.
``` erb
<%= div_for(comment) do %>
  <div class="comments_wrapper clearfix">
    <div class="pull-left">
      <p class="lead"><%= comment.body %></p>
      <p><small>Submitted <strong><%= time_ago_in_words(comment.created_at) %> ago</strong> by <%= comment.user.email %></small></p>
    </div>

    <div class="btn-group pull-right">
      <% if comment.user == current_user %>
        <%= link_to 'Destroy', comment, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-sm btn-default" %>
      <% end %>
    </div>
  </div>
<% end %>
```
>div_for를 작동시키기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'record_tag_helper', '~> 1.0', '>= 1.0.1'
```
``` terminal
sudo gem install record_tag_helper
```
>잘 동작하는지 확인하기 링크를 클릭하여 확인합니다.
>app/views/links/index.html.erb의 오타를 수정합니다.
``` erb
# before
small class="author">Submitted <%= time_ago_in_words(link.created_at) %> by <%= link.user.email %></small>
# after
small class="author">Submitted <%= time_ago_in_words(link.created_at) %> ago by <%= link.user.email %></small>
```
>가입시 사용자 이름을 추가하기 위해 다음을 마이그레이션하고 app/views/devise/registration/edit.html.erb에 다음을 추가합니다.
``` terminal
$ sudo rails generate migration add_name_to_users name:string
$ sudo rake db:migrate
```
``` erb
<div class="form-group">
  <%= f.label :name %>
  <%= f.text_field :name, class: "form-control", :autofocus => true %>
</div>
```
>app/controllers/application_controller.rb를 다음과 같이 수정합니다.
``` rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
```
>app/controllers/views/links/index.html.erb를 수정해줍니다.
``` erb
<!-- before -->
<small class="author">Submitted <%= time_ago_in_words(link.created_at) %> ago by <%= link.user.email %></small>
<!-- after -->
<small class="author">Submitted <%= time_ago_in_words(link.created_at) %> ago by <%= link.user.name %></small>
```
>app/controllers/views/links/show.html.erb를 수정해줍니다.
``` erb
<!-- before -->
<small>Submitted by <%= @link.user.email %></small>
<!-- after -->
<small>Submitted by <%= @link.user.name %></small>
```
>app/controllers/views/comments/_comment.html.erb를 수정해줍니다.
``` erb
<!-- before -->
<p><small>Submitted <strong><%= time_ago_in_words(comment.created_at) %> ago</strong> by <%= comment.user.email %></small></p>
<!-- after -->
<p><small>Submitted <strong><%= time_ago_in_words(comment.created_at) %> ago</strong> by <%= comment.user.name %></small></p>
```
>app/controllers/views/devise/registrations/new.html.erb를 추가해줍니다.
``` erb
<div class="form-group">
  <%= f.label :name %>
  <%= f.text_field :name, class: "form-control", :autofocus => true %>
</div>
```
>이로써 link 작성자, comment 작성자를 이메일이 아닌 이름으로 표시하게 되었습니다.    
>Reddit Clone 프로젝트를 마칩니다.    
---    
## Blog
- 2020-10-24
>레일즈 프로젝트를 생성합니다.    
>프로젝트 폴더로 이동합니다.
``` terminal
$ sudo rails new blog
$ cd blog/
```
>레일즈 서버를 켜서 잘 동작하는지 확인합니다.
``` terminal
$ sudo rails server
```
>post 컨트롤러를 생성합니다.
``` terminal
$ sudo rails generate controller posts
```
>경로 설정을 위해 app/config/routes.rb에 다음을 추가합니다.    
>index를 정의하기 위해 app/controllers/posts/posts_controller.rb에 다음을 추가합니다.    
>app/views/posts/index.html.erb 파일을 만들어 다음을 추가합니다.
``` rb
# routes.rb
resources : posts
root "posts#index"
```
``` rb
# posts_controller.rb
def index
end
```
``` erb
<!-- index.html.erb -->
<h1>This is the index.html.erb file... Yay!</h1>
```
>잘 동작하는지 확인해줍니다.    
>post를 새로 만드는 것을 구현하기 위해 app/controllers/posts/posts_controller.rb에 다음을 추가합니다.    
>post를 새로 만들 수 있도록 app/views/posts/new.html.erb 파일을 만들어 다음을 추가합니다.
``` rb
def new
end
```
``` erb
<h1>New Post</h1>

<%= form_for :post, url: posts_path do |f| %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>

  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>
```
>post 모델을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model Post title:string body:text
$ sudo rake db:migrate
```
>app/controller/posts_controller.rb에 create와 show, private 메소드를 추가합니다.    
>생성한 post를 볼 수 있는 페이지를 위해 app/views/posts/show.html.erb 생성하고 코드를 추가해줍니다.
``` rb
def create
  @post = Post.new(post_params)
  @post.save

  redirect_to @post
end

private
  def post_params
    params.require(:post).permit(:title, :body)
  end
```
``` erb
<h1 class="title">
  <%= @post.title %>
</h1>

<p class="date">
  Submitted <%= time_ago_in_words(@post.created_at) %> Ago
</p>

<p class="body">
  <%= @post.body %>
</p>
```
>index에서 post를 확인하기 위해 app/controller/posts_controller.rb를 다음과 같이 수정해줍니다.    
>app/views/posts/index.html.erb를 다음과 같이 수정해줍니다.
``` rb
# before
def index
end
# after
def index
  @posts = Post.all.order('Created_at DESC')
end
```
``` erb
<% @posts.each do |post| %>
  <div class="post_wrapper">
    <h2 class="title"><%= link_to post.title, post %></h2>
    <p class="date"><%= post.created_at.strftime("%B, %d, %Y") %></p>
  </div>
<% end %>
```
>블로그 스타일링을 위해 app/views/layouts/application.html.erb를 추가해줍니다.    
>app/assets/images/logo.svg를 추가해줍니다.    
>app/assets/stylesheets/application.css 를 [application.scss](https://github.com/mackenziechild/blog/blob/master/app/assets/stylesheets/application.css.scss)을 이용하여 수정하고, app/assets/stylesheets/_normalize.scss를 추가하고 [_normalize.scss](https://github.com/mackenziechild/blog/blob/master/app/assets/stylesheets/_normalize.css.scss)를 이용하여 수정해줍니다.
``` erb
<!-- 생략 -->
<%= stylesheet_link_tag 'application', 'http://fonts.googleapis.com/css?family=Raleway:400,700' %>
<!-- 중략 -->
<div id="sidebar">
  <div id="logo">
    <%= link_to root_path do %>
      <%= image_tag "logo.svg" %>
    <% end %>
  </div>

  <ul>
    <li class="category">Website</li>
    <li><%= link_to "Blog", root_path %></li>
    <li>About</li>
  </ul>

  <ul>
    <li class="category">Social</li>
    <li><a href="">Twitter</a></li>
    <li><a href="http://instagram.com/p_xzhu">Instagram</a></li>
    <li><a href="https://github.com/pxzhu">Github</a></li>
    <li><a href="mailto:wearan0nsgat@gmail.com">Email</a></li>
  </ul>

  <p class="sign_in">Admin Login</p>
</div>
<div id="main_content">
  <div id="header">
    <p>All Posts</p>

    <div class="buttons">
      <button class="button"><%= link_to "New Post", new_post_path %></button>
      <button class="button">Log Out</button>
    </div>
  </div>

  <% flash.each do |name, msg| %>
    <%= content_tag(:div, msg, class: "alert") %>
  <% end %>

  <%= yield %>
</div>
```
>새 post의 디자인을 바꾸기 위해 app/views/posts/new.html.erb를 전체적으로 묶어줍니다.
``` erb
<div id="page_wrapper">
  <!-- 중략 -->
</div>
```
>post 목록의 디자인을 바꾸기 위해 app/views/posts/show.html.erb를 전체적으로 묶어줍니다.
``` erb
<div id="post_conetnt">
  <!-- 중략 -->
</div>
```
>post를 작성할 때 빈칸으로 완료하거나 제목 길이가 너무 짧지 않게 하기 위해 app/models/post.rb에 다음을 추가해줍니다.    
> app/controllers/posts_controller.rb의 new 메소드와 create 메소드를 수정해줍니다.
``` rb
validates :title, presence: true, length: { minimum: 5 }
validates :body, presence: true
```
``` rb
# before
def new
end
def create
  @post = Post.new(post_params)
  @post.save

  redirect_to @post
end
# after
def new
    @post = Post.new
  end
def create
  @post = Post.new(post_params)

  if @post.save
    redirect_to @post
  else
    render 'new'
  end
end
```
>post 작성 시 오류가 발생하면 오류를 알려주는 것을 만들기 위해 app/views/posts/new.html.erb에 다음을 추가해줍니다.
``` erb
<!-- 생략 -->
<%= form_for :post, url: posts_path do |f| %>
  <% if @post.errors.any? %>
    <div id="errors">
      <h2><%= pluralize(@post.errors.count, "error") %> pervented this post from saving</h2>
      <ul>
        <% @post.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>>
        <% end %>
      </ul>
    </div>
  <% end %>
  <p>
<!-- 이하 생략 -->
```
>post 수정을 위해 app/controllers/posts_controller.rb에 다음을 추가합니다.
``` rb
# 생략
def edit
  @post = Post.find(params[:id])
end
def update
  @post = Post.find(params[:id])  

  if @post.update(params[:post].permit(:title, :body))
    redirect_to @post
  else
    render 'edit'
  end
end
# 이하 생략
```
>app/views/posts/_form.html.erb 파일을 만들고 다음을 추가합니다.    
``` erb
<%= form_for @post do |f| %>
  <% if @post.errors.any? %>
    <div id="errors">
      <h2><%= pluralize(@post.errors.count, "error") %> pervented this post from saving</h2>
      <ul>
        <% @post.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>>
        <% end %>
      </ul>
    </div>
  <% end %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>

  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>
```
>app/views/posts/new.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<div id="page_wrapper">
  <h1>New Post</h1>

  <%= render 'form' %>
</div>
```
>app/views/posts/edit.html.erb 파일을 만들고 다음을 추가합니다.
``` erb
<div id="page_wrapper">
  <h1>New Post</h1>

  <%= render 'form' %>
</div>
```
>app/views/posts/show.html.erb 파일에 다음을 추가합니다.
``` erb
<!-- 생략 -->
Submitted <%= time_ago_in_words(@post.created_at) %> Ago
| <%= link_to 'Edit', edit_post_path(@post) %>
<!-- 이하 생략 -->
```
>post 삭제를 위해 app/controllers/posts_controller.rb에 다음을 추가합니다.
``` rb
# 생략
def destroy
  @post = Post.find(params[:id])
  @post.destroy

  redirect_to root_path
end
# 이하 생략
```
>app/views/posts/show.html.erb 파일에 다음을 추가합니다.
<!-- 생략 -->
| <%= link_to 'Edit', edit_post_path(@post) %>
| <%= link_to 'Delete', post_path(@post), method: :delete, data: { confirm: 'Are you sure?' } %>
<!-- 이하 생략 -->
```
>comment 기능을 추가하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model Comment name:string body:text post:references
$ sudo rake db:migrate
```
>app/models/post.rb에 다음을 추가합니다.
``` rb
has_many :comments
```
>post가 존재할 때 comment가 존재하도록 config/route.rb를 수정해줍니다.
``` rb
# before
resources :posts
root "posts#index"
# after
resources :posts do
  resources :comments
end
root "posts#index"
```
>comment의 controller를 생성해줍니다.
``` terminal
$ sudo rails generate controller Comments
```
>comment가 동작할 수 있도록 app/controllers/comments_controller.rb 파일에 다음을 추가해줍니다.
``` rb
def create
  @post = Post.find(params[:post_id])
  @comment = @post.comments.create(params[:comment].permit(:name, :body))

  redirect_to post_path(@post)
end
```
>app/views/comments/_comment.html.erb와 _form.html.erb를 생성해줍니다.    
>_form.html.erb에 다음과 같이 폼을 만들어줍니다.
``` erb
<%= form_for([@post, @post.comments.build]) do |f| %>
  <p>
    <%= f.label :name %><br>
    <%= f.text_field :name %>
  </p>
  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>
  <br>
  <p>
    <%= f.submit %>
  </p>
<% end %>
```
>_comment.html.erb에 다음과 같이 디자인을 해줍니다.
``` erb
<div class="comment clearfix">
  <div class="comment_content">
    <p class="comment_name"><strong><%= comment.name %></strong></p>
    <p class="comment_body"><%= comment.body %></p>
    <p class="comment_time"><%= time_ago_in_words(comment.created_at) %> Ago</p>
  </div>
</div>
```
>post에 comment를 작성할수 있는 폼을 추가하기 위해 app/views/posts/show.html.erb에 다음을 추가해줍니다.
``` erb
<!-- 생략 -->
  <div id="comments">
    <h2><%= @post.comments.count %> Comments</h2>
    <%= render @post.comments %>

    <h3>Add a comment: </h3>
    <%= render "comments/form" %>
  </div>
</div>
```
>comment 삭제 기능을 위해 app/controllers/comments_controller.rb 파일에 다음을 추가합니다.
``` rb
def destroy
  @post = Post.find(params[:post_id])
  @comment = @post.comments.find(params[:id])
  @comment.destroy

  redirect_to post_path(@post)
end
```
>comment 삭제 버튼을 만들기 위해 app/views/comments/_comment.html.erb 파일에 다음을 추가합니다.
``` erb
<p><%= link_to 'Delete', [comment.post, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure?' } %></p>
```
>destroy 메소드를 동작하게 하기 위해서 app/models/post.rb를 다음과 같이 수정합니다.
``` rb
# before
has_many :comments
# after
has_many :comments, dependent: :destroy
```
>About을 사용하기 위해 pages 컨트롤러를 생성합니다.
``` terminal
$ sudo rails generate controller pages
```
>about 메소드를 정의하기 위해 app/controllers/pages_controller.rb 파일에 다음을 추가합니다.
``` rb
def about
end
```
>경로를 설정하기 위해 config/routes.rb 파일에 다음을 추가해줍니다.
``` rb
# 생략
get '/about'. to: 'pages#about'
```
>app/views/pages/about.html.erb 파일에 다음을 추가하여 about 페이지를 만들어줍니다.
``` erb
<div id="page_wrapper">
  <div id="profile_image">
    <%= image_tag "profile.jpeg" %>
  </div>

  <div id="content">
    <h1>Hey, I'm Pxzhu</h1>
    <p>Welcome to week 2 of my 12 Web Apps Challenge.</p>
    <p>This Challenge is I built a blog in Rails. You're actually on the demo application right now. Cool stuff, right!</p>
    <p>If you'd like to follow along as I learn more Ruby on Rails, find me on Github <a href="https://github.com/pxzhu">pxzhu</a> or Email to <a herf="mailto:wearan0nsgat@gmail.com">HERE!</a></p>
  </div>
</div>
```
>About 버튼 활성화를 위해 app/views/layouts/application.html.erb 파일의 다음을 수정합니다.
``` erb
<!-- before -->
<li>About</li>
<!-- after -->
<li><%= link_to "About", about_path %></li>
```
>About 화면일 때, post 화면일 때 header의 정보를 바꿔주기 위하여 app/views/layouts/application.html.erb 파일의 다음을 수정합니다.
``` erb
<!-- before -->
<div id="header">
  <p>All Posts</p>
<!-- after -->
<div id="header">
  <% if current_page?(root_path) %>
    <p>All Posts</p>
  <% elsif current_page?(about_path) %>
    <p>About</p>
  <% else %>
    <%= link_to "Back to All Posts", root_path %>
  <% end %>
```
>로그인 기능을 사용하기 위해 devise를 설치합니다.    
>devise 설치를 위해 Gemfile에 다음을 추가해줍니다.    
>devise를 설치해줍니다.
``` gemfile
gem 'deivse'
```
``` terminal
$ sudo bundle install
```
>레일즈 서버를 켠 상태로 devise를 설치해줍니다.    
>다음을 복사한 뒤 config/environments/development.rb 하단에 추가해줍니다.    
``` terminal
$ sudo rails generate devise:install
  => ...
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    ...
```
>devise의 views도 생성해줍니다.    
>User도 생성한 뒤 마이그레이션해줍니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>다음 주소에서 페이지가 잘 동작하는지 확인하고 회원가입을 합니다.
```
localhost:3000/users/sign_up
```
>app/views/devise/sessions/new.html.erb에서 최상단과 최하단에 다음을 추가해줍니다.    
>중간중간 보기 좋게 줄 바꿈 태그도 넣어줍니다.
``` erb
<div id="page_wrapper">
</div>
```
>app/controllers/posts_controller.rb 상단에 다음을 추가합니다.
``` rb
before_action :authenticate_user!, except: [:index, :show]
```
>로그인한 user만 Log Out이 표시되게 app/views/layouts/application.html.erb를 다음과 같이 수정합니다.
``` erb
<!-- before -->
<div class="buttons">
  <button class="button"><%= link_to "New Post", new_post_path %></button>
  <button class="button">Log Out</button>
</div>
<!-- after -->
<% if user_signed_in? %>
  <div class="buttons">
    <button class="button"><%= link_to "New Post", new_post_path %></button>
    <button class="button">Log Out</button>
  </div>
<% end %>
```
>로그인하지 않은 user만 Admin Login이 표시되게 다음과 같이 수정합니다.
``` erb
<!-- before -->
<p class="sign_in">Admin Login</p>
<!-- after -->
<% if !user_signed_in? %>
  <p class="sign_in">Admin Login</p>
<% end %>
``` 
>로그인한 user만 post를 수정, 삭제할 수 있게 하기 위하여 app/views/posts/show.html.erb를 다음과 같이 수정합니다.
``` erb
<!-- before -->
| <%= link_to 'Edit', edit_post_path(@post) %>
| <%= link_to 'Delete', post_path(@post), method: :delete, data: { confirm: 'Are you sure?' } %>
<!-- after -->
<% if user_signed_in? %>
  | <%= link_to 'Edit', edit_post_path(@post) %>
  | <%= link_to 'Delete', post_path(@post), method: :delete, data: { confirm: 'Are you sure?' } %>
<% end %>
```
>로그인한 user만 comment를 삭제할 수 있게 하기 위하여 app/views/comments/_comment.html.erb를 다음과 같이 수정합니다.
``` erb
<!-- before -->
<p><%= link_to 'Delete', [comment.post, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure?' } %></p>
<!-- after -->
<% if user_signed_in? %>
  <p><%= link_to 'Delete', [comment.post, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure?' } %></p>
<% end %>
<% end %>
```
---    

## Recipe Box
- 2020-10-25
>레일즈 프로젝트를 생성합니다.    
>프로젝트 폴더로 이동합니다.    
>서버를 켜서 잘 동작하는지 확인합니다.
``` terminal
$ sudo rails new recipe_box
$ cd recipe_box/
$ sudo rails server
```
>html 대신 사용하기 위해 Gemfile에 haml을 추가하고 설치해줍니다.
``` gemfile
gem 'haml', '~> 5.2'
```
``` terminal
$ gem install haml
```
>recipe 컨트롤러를 생성합니다.    
``` terminal
$ sudo rails generate controller recipes
```
>config/routes.rb 파일에 다음을 추가하여 경로를 설정합니다.
``` rb
resources :recipes

root "recipes#index"
```
>app/controllers/recipes_controller.rb 파일에 다음을 추가해줍니다.    
>app/views/recipes/index.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` rb
before_action :find_recipe, only: [:show, :edit, :update, :destroy]

def index
end
def show
end
def new
  @recipe = Recipe.new
end
def create
  @recipe = Recipe.new(recipe_params)

  if @recipe.save
    redirect_to @recipe, notice: "Successfully created new recipe"
  else
    render 'new'
  end
end

private

def recipe_params
  params.require(:recipe).permit(:title, :description)
end
def find_recipe
  @recipe = Recipe.find(params[:id])
end
```
``` haml
%h1 This is the placeholder for the Recipes#Index
```
>Recipe 모델을 만들고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model Recipe title:string description:text user_id:integer
$ sudo rake db:migrate
```
>app/views/recipes 폴더에 _form.html.haml 과 new.html.haml 파일을 생성해줍니다.    
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'simple_form', '~> 5.0', '>= 5.0.3'
```
``` terminal
$ sudo gem install simple_form
```
>app/views/recipes/_form.html.haml 파일에 다음을 추가합니다.    
>app/views/recipes/new.html.haml 파일에 다음을 추가합니다.
``` haml
= simple_form_for @recipe, html: { multipart: true } do |f|
  - if @recipe.errors.any?
    #errors
      %p
        = @recipe.errors.count
        Prevented this recipe froms saving
      %ul
        - @recipe.errors.full_messages.each do |msg|
          %li= msg
  .panel-body
    = f.input :title, input_html: { class: 'form-control' }
    = f.input :description, input_html: { class: 'form-control' }

  = f.button :submit, class: "btn btn-primary"
```
``` haml
%h1 New Recipe

= render 'form'

%br

= link_to "Back", root_path, class: "btn btn-default"
```
>만들어진 recipe를 보기 위해 app/views/recipes/show.html.haml 파일을 만들고 다음을 추가합니다.
``` haml
%h1= @recipe.title
%p= @recipe.description

= link_to "Back", root_path, class: "btn btn-default"
```
>index 화면에서 레시피 링크를 볼 수 있도록 app/controllers/recipes_controller.rb 파일의 다음을 수정해줍니다.    
>app/views/recipres/index.html.haml 파일도 수정해줍니다.
``` rb
# before
def index
end
# after
def index
  @recipe = Recipe.all.order("created_at DESC")
end
```
``` haml
- @recipe.each do |recipe|
  %h3= link_to recipe.title, recipe
```
>수정과 삭제 기능을 위해 app/controllers/recipes_controller.rb 파일에 다음을 추가해줍니다.    
``` rb
def edit
end
def update
  if @recipe.update(recipe_params)
    redirect_to @recipe
  else
    render 'edit'
  end
end
def destroy
  @recipe.destroy
  redirect_to root_path, notice: "Successfully deleted recipe"
end
```
>수정 화면을 구현하기 위해 app/views/recipes 폴더에 edit.html.haml 파일을 만들고 다음을 추가해줍니다.
``` haml
%h1 Edit Recipe

=render 'form'
```
>app/views/recipres/show.html.haml 파일에 다음을 추가해줍니다.
``` haml
= link_to "Edit", edit_recipe_path, class: "btn btn-default"
= link_to "Delete", recipe_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
```
>bootstrap-sass 설치를 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'bootstrap-sass', '~> 3.4', '>= 3.4.1'
```
``` terminal
$ sudo gem install bootstrap-sass
```
>app/assets/stylesheets/application.css 파일을 application.scss로 이름을 변경하고 다음을 추가해줍니다.    
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>app/views/layouts/application.html.erb 파일을 application.html.haml로 이름을 변경하고 다음처럼 수정해줍니다.
``` haml
!!! 5
%html
%head
  %title Recipe App
  = csrf_meta_tags
  = csp_meta_tag

  = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
  = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'

%body
  %nav.navbar.navbar-default
    .container
      .navbar-brand= link_to "Recipe Box", root_path

      %ul.nav.navbar-nav.navbar-right
        %li= link_to "New Recipe", new_recipe_path
        %li= link_to "Sign Out", root_path

  .container
    - flash.each do |name, msg|
      = content_tag :div, msg, class: "alert"
    = yield
```
>paperclip을 설치하기 위해 Gemfile을 수정하고 설치해줍니다.
``` gemfile
gem 'paperclip', '~> 6.1'
```
``` terminal
$ sudo gem install paperclip
```
>app/models/recipe.rb 파일에 다음을 추가합니다.
``` rb
has_attached_file :image, styles: { :medium => "400x400#" }
validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
```
>paperclip을 생성하고 마이그레이션해줍니다.    
>오류 발생 시 db/migrate 폴더에 있는 add_attachment_image_to_recipes.rb 파일을 다음과 같이 수정합니다.
``` terminal
$ sudo rails generate paperclip recipe image
$ sudo rake db:migrate
```
``` rb
# before
class AddAttachmentImageToRecipes < ActiveRecord::Migration
# after
class AddAttachmentImageToRecipes < ActiveRecord::Migration[6.0]
```
>app/views/recopes/_form.html.haml 파일에 다음을 추가해줍니다.
``` haml
= f.input :iamge, input_html: { class: 'form-control' }
```
>app/controllers/recipes_controller.rb 파일을 다음과 같이 수정해줍니다.
``` rb
# before
def recipe_params
  params.require(:recipe).permit(:title, :description)
end
# after
def recipe_params
  params.require(:recipe).permit(:title, :description, :image)
end
```
>잘 동작하는지 확인해봅니다.    
>잘 동작한다면 app/views/recipes/show.html.haml 파일 최상단에 다음을 추가합니다.
``` haml
= image_tag @recipe.image.url(:medium, class: "recipe_image")
```
>index 화면에도 image를 표시하기 위해  app/views/recipres/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
# before
- @recipe.each do |recipe|
  %h3= link_to recipe.title, recipe
# after
- @recipe.each do |recipe|
  = link_to recipe do
    = image_tag recipe.image.url(:medium)
  %h3= link_to recipe.title, recipe
```
>app/assets/stylesheets/application.scss 파일을 [여기](https://github.com/mackenziechild/recipe_box/blob/master/app/assets/stylesheets/application.css.scss)를 참고하여 스타일을 붙여 넣어줍니다.    
>coccon을 설치하기 위해 Gemfile을 수정하고 설치해줍니다.
``` gemfile
gem 'cocoon', '~> 1.2', '>= 1.2.15'
```
``` terminal
$ sudo gem install cocoon
```
>cocoon을 불러오기 위해 app/javascript/packs/application.js 파일에 다음을 추가해줍니다.    
>모델을 생성해줍니다.
``` js
require("jquery")
require("@nathanvda/cocoon")
```
``` terminal
$ sudo rails generate model Ingredient name:string recipe:belongs_to
$ sudo rails generate model Direction step:text recipe:belongs_to
$ sudo rake db:migrate
```
>app/models/recipe.rb 파일에 다음을 추가합니다.
``` rb
has_many :infredients
has_many :directions

accepts_nested_attributes_for :ingredients,
                              reject_if: proc { |attributes| attributes['name'].blank? },
                              allow_destroy: true
accepts_nested_attributes_for :directions,
                              reject_if: proc { |attributes| attributes['step'].blank? },
                              allow_destroy: true

validates :title, :description, :image, presence: true
```
>app/controllers/recipes_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
params.require(:recipe).permit(:title, :description, :image)
# after
params.require(:recipe).permit(:title, :description, :image, ingredients_attributes: [:id, :name, :_destroy], directions_attributes: [:id, :step, :_destroy])
```
>app/views/recipes/_form.html.haml 파일에 다음을 추가합니다.
``` haml
<!-- 생략 -->
.row
  .col-md-6
    %h3 Ingredients
    #ingredients
      = f.simple_fields_for :ingredients do |ingredient|
        = render 'ingredient_fields', f: ingredient
      .links
        = link_to_add_association 'Add Ingredient', f, :ingredients, class: "btn btn-default add-button"
  .col-md-6
    %h3 Directions
    #directions
      = f.simple_fields_for :directions do |direction|
        = render 'direction_fields', f: direction
      .links
        = link_to_add_association 'Add Step', f, :directions, class: "btn btn-default add-button"
<!-- 이하 생략 -->
```
>app/views/recipes/_ingredient_fields.html.haml 파일을 만들고 다음을 추가합니다.
``` haml
.form-inline.clearfix
  .nested-fields
    = f.input :name, input_html: { class: 'form-input form-control' }
    = link_to_remove_association "Remove", f, class: "form-button btn btn-default"
```
>app/views/recipes/_derection_fields.html.haml 파일을 만들고 다음을 추가합니다.
``` haml
.form-inline.clearfix
  .nested-fields
    = f.input :step, input_html: { class: 'form-input form-control' }
    = link_to_remove_association "Remove Step", f, class: "btn btn-default form-button"
```
>cocoon이 제대로 작동하지 않을 것입니다.    
>다음을 실행합니다.
``` terminal
$ sudo yarn add cocoon-js
```
>app/javascripts/packs/application.js 파일에 다음을 추가합니다.
``` js
import 'cocoon-js';
```
>app/views/recipes/show.html.haml 파일을 다음과 같이 수정합니다.
``` haml
.main_content
  #recipe_top.row
    .col-md-4
      = image_tag @recipe.image.url(:medium), class: "recipe_image"
    .col-md-8
      #recipe_info
        %h1= @recipe.title
        %p.description= @recipe.description
    
  .row
    .col-md-6
      #ingredients
        %h2 Ingredients
        %ul
          - @recipe.ingredients.each do |ingredient|
            %li= ingredient.name
    .col-md-6
      #directions
        %h2 Directions
        %ul
          - @recipe.directions.each do |direction|
            %li= direction.step

  .row
    .col-md-12
      = link_to "Back", root_path, class: "btn btn-default"
      = link_to "Edit", edit_recipe_path, class: "btn btn-default"
      = link_to "Delete", recipe_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
```
>Ingredients와 Directions가 존재하면 삭제 시 500 Error가 발생한다.    
- 2020-10-26
>devise를 설치하기 위해 Gemfile에 다음을 추가하고 설치합니다.
``` gemfile
gem 'devise', '~> 4.7', '>= 4.7.3'
```
``` terminal
$ sudo gem install devise
$ sudo rails generate devise:install
```
>devise를 사용하기 위해 config/environments/development.rb 파일에 다음을 추가합니다.    
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>views를 생성해줍니다.    
>User를 생성해줍니다.    
>마이그레이션을 해줍니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>app/models/user.rb 파일에 다음을 추가합니다.    
>app/models/recipe.rb 파일에 다음을 추가합니다.    
``` rb
has_many :recipes
```
``` rb
belongs_to :user
```
>app/controllers/recipes_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
# 생략
def new
  @recipe = Recipe.new
end
def create
  @recipe = Recipe.new(recipe_params)
# 이하 생략
# after
# 생략
def new
  @recipe = current_user.recipes.build
end
def create
  @recipe = current_user.recipes.build(recipe_params)
# 이하 생략
```
>레일즈 콘솔에서 다음과 같이 레시피를 생성하고 유저를 추가합니다.
``` terminal
$ sudo rails c
$ @recipe = Recipe.new
$ @recipe = current_user.recipes.build
```
>app/views/recipre/show.html.haml 파일에 다음을 추가합니다.
``` haml
<!-- 생략 -->
%p
  Submitted by
  = @recipe.user.email
<!-- 이하 생략 -->
```
>app/views/layouts/application.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
<!-- before -->
<!-- 생략 -->
%ul.nav.navbar-nav.navbar-right
  %li= link_to "New Recipe", new_recipe_path
  %li= link_to "Sign Out", root_path
<!-- 이하 생략 -->
<!-- after -->
<!-- 생략 -->
- if user_signed_in?
  %ul.nav.navbar-nav.navbar-right
    %li= link_to "New Recipe", new_recipe_path
    %li= link_to "Sign Out", destroy_user_session_path, method: :delete
- else
  %ul.nav.navbar-nav.navbar-right
    %li= link_to "Sign Up", new_user_registration_path
    %li= link_to "Sign in", new_user_session_path
<!-- 이하 생략 -->
```
>app/views/recipes/show.htrml.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
<!-- 생략 -->
= link_to "Edit", edit_recipe_path, class: "btn btn-default"
= link_to "Delete", recipe_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
<!-- after -->
<!-- 생략 -->
- if user_signed_in?
  = link_to "Edit", edit_recipe_path, class: "btn btn-default"
  = link_to "Delete", recipe_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
```
>Sign in 페이지에 디자인을 입히기 위해 app/views/sessions/new.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <h2>Sign in</h2>

    <%= simple_form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
      <div class="form-inputs">
        <%= f.input :email,
                    required: false,
                    autofocus: true,
                    input_html: { class: 'form-control' } %>
        <%= f.input :password,
                    required: false,
                    input_html: { class: 'form-control' } %>
        <%= f.input :remember_me, as: :boolean, class: 'form-control' if devise_mapping.rememberable? %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Sign in", class: 'btn btn-primary' %>
      </div>
      <br>
    <% end %>
    
    <%= render "devise/shared/links" %>
  </div>
</div>
```
>Sign Up 화면을 디자인하기 위해 app/views/devise/registrations/new.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <h2>Sign up</h2>

    <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
      <%= f.error_notification %>

      <div class="form-inputs">
        <%= f.input :email,
                    required: true,
                    autofocus: true,
                    input_html: { class: 'form-control' }%>
        <%= f.input :password,
                    required: true,
                    hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                    input_html: { class: 'form-control' } %>
        <%= f.input :password_confirmation,
                    required: true,
                    input_html: { class: 'form-control' } %>
      </div>
      <br>
      <div class="form-actions">
        <%= f.button :submit, "Sign up", class: "btn btn-primary" %>
      </div>
      <br>
    <% end %>

    <%= render "devise/shared/links" %>
  </div>
</div>
```
---

## Pinterest Clone
- 2020-10-28
>레일즈 프로젝트를 생성합니다.
``` terminal
$ sudo rails new pinterestclone
```
>프로젝트 폴더로 이동합니다.    
>레일즈 서버를 시작해줍니다.    
``` terminal
$ cd pinterestclone
$ sudo rails server
```
>haml, bootstrap-sass, simple_form을 설치하기 위해 Gemfile에 다음을 추가하고 설치합니다.
``` gemfile
gem 'haml', '~> 5.2'
gem 'bootstrap-sass', '~> 3.4', '>= 3.4.1'
gem 'simple_form', '~> 5.0', '>= 5.0.3'
```
``` terminal
$ sudo gem install haml
$ sudo gem install bootstrap-sass
$ sudo gem install simple_form
```
>Pin 모델을 생성하고 마이그레이션 한 뒤 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate model Pin title:string description:text
$ sudo rake db:migrate
$ sudo rails generate controller Pins
```
>app/controllers/pins_controller.rb 파일에 index 메소드를 생성합니다.
``` rb
def index
end
```
>config/routes.rb 파일에 경로를 설정해줍니다.
``` rb
resources :pins

root "pins#index"
```
>index 화면을 추가하기 위해 app/views/pins 폴더에 index.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
%h1 This is the index placeholder
```
>잘 동작하는지 확인한 뒤, pin 생성을 위해 app/controllers/pins_controller.rb 파일에 다음을 추가합니다.
``` rb
before_action :find_pin, only: [:show, :edit, :update, :destroy]
# 중략
def show
end
def new
  @pin = Pin.new
end
def create
  @pin = Pin.new(pin_params)

  if @pin.save
    redirect_to @pin, notice: "Successfully created new Pin"
  else
    render 'new'
  end
end

private

def pin_params
  params.require(:pin).permit(:title, :description)
end
def find_pin
  @pin = Pin.find(params[:id])
end
```
>pin을 생성하기 위해 app/views/pins/new.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
%h1 New Form

= render 'form'

= link_to "Back", root_path
```
>simple_form을 쉽게 사용하기 위해 터미널에서 다음을 설치해줍니다.
``` terminal
$ sudo rails generate simple_form:install --bootstrap
```
>pin을 보기 위한 form을 위해 app/view/pins/_form/html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
= simple_form_for @pin, html: { multipart: true } do |f|
  - if @pin.errors.any?
    #errors
      %h2
      = pluralize(@pin.errors.count, "error")
      prevented this Pin from saving
      %ul
        - @pin.errors.full_messages.each do |msg|
          %li= msg
  
  .form-group
    = f.input :title, input_html: { class: 'form-control' }

  .form-group
    = f.input :description, input_html: { class: 'form-control' }

  = f.button :submit, class: "btn btn-primary"
```
>app/views/layouts/application.html.erb 파일을 application.html.haml 파일로 바꾸고 다음과 같이 수정합니다.
``` haml
!!! 5
%html
%head
  %title Pin Board
  = csrf_meta_tags
  = csp_meta_tag

  = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
  = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'

%body
  - flash.each do |name, msg|
    = content_tag :div, msg, class: "alert alert-info"

  = yield
```
>생성한 pin을 보기 위해 app/views/pins 폴더에 show.html.haml 파일을 만들고 다음을 추가해줍니다.
``` haml
%h1= @pin.title
%p= @pin.description

= link_to "Back", root_path
```
>index 화면에서 pin으로 이동할 수 있게 하기 위해 app/views/pins/index.html.haml 파일을 다음과 같이 수정합니다.    
>app/controllers/pins_controller.rb 파일도 다음과 같이 수정합니다.
``` haml
- @pins.each do |pin|
  %h2= link_to pin.title, pin
```
``` rb
# before
def index
end
# after
def index
  @pins = Pin.all.order("created_at DESC")
end
```
- 2020-10-30
>app/controllers/pins_controller.rb 파일에 다음을 추가해줍니다.
``` rb
def edit
end
def update
  if @pin.update(pin_params)
    redirect_to @pin, notice: "Pin was Successfully updated!!"
  else
    render 'edit'
  end
end
def destroy
end
```
>app/views/pins/edit.html.haml 파일을 생성하고 다음을 추가해줍니다.    
>app/views/pins/show.html.haml 파일에 다음을 추가해줍니다.
``` haml
%h1 Edit Pin

= render 'form'

= link_to "Cancle", pin_path
```
``` haml
= link_to "Edit", edit_pin_path
```
>app/controllers/pins_controller.rb 파일을 다음과 같이 수정합니다.    
>app/views/pins/show.html.haml 파일에 다음을 추가해줍니다.
``` rb
# before
def destroy
end
# after
def destroy
  @pin.destroy
  redirect_to root_path
end
```
``` haml
= link_to "Delete", pin_path, method: :delete, data: { confirm: 'Are you sure?' }
```
>app/views/pins/index.html.haml 파일 최상단에 다음을 추가해줍니다.
``` haml
=link_to "New Pin", new_pin_path
```
- 2020-10-31
>User를 추가하기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'devise', '~> 4.7', '>= 4.7.3'
```
``` terminal
$ sudo gem install devise
$ sudo rails generate devise:install
```
>config/environments/development.rb 파일에 다음을 추가합니다.
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>views와 User 모델을 만들고 마이그레이션합니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>app/models/user.rb 파일에 다음을 추가합니다.    
>app/models/pin.rb 파일에 다음을 추가합니다.
``` rb
has_many :pins
```
``` rb
belongs_to :user
```
>User를 Pins에 마이그레이션해줍니다.
``` terminal
$ sudo rails generate migration add_user_id_to_pins user_id:integer:index
$ sudo rake db:migrate
```
>레일즈 콘솔에 들어가서 pin 게시물에 user를 추가해줍니다.
``` terminal
$ sudo rails c
$ @pin = Pin.first
$ @user = User.first
$ @pin.user = @user
$ @pin
  =>Pin id: 2, title: "This is my first Pin,(Edit)", description: "I'm baby iPhone XOXO williamsburg pok pok twee qui...", created_at: "2020-10-28 12:42:52", updated_at: "2020-10-30 12:04:18", user_id: 1
$ @pin.save
```
>pin 게시물의 작성자 표시를 위해 app/views/pins/show.html.haml 파일에 다음을 추가합니다.
``` haml
%p
Submitted by 
=@pin.user.email

%br
```
>pin 게시물 생성 시에 작성자를 함께 넣기 위해 app/controllers/pins_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
  @pin = Pin.new
end
def create
  @pin = Pin.new(pin_params)
# after
  @pin = current_user.pins.build
end
def create
  @pin = current_user.pins.build(pin_params)
```
- 2020-11-01
>스타일을 설정하기위해 app/assets/stylesheets/application.css 파일을 application.scss 파일로 변경하고 다음을 추가합니다.
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>Gemfile에 jQuery를 추가하고 설치해줍니다.
``` gemfile
gem 'jquery-rails'
```
``` terminal
$ sudo bundle install
```
>app/javascript/packs/application.js 파일에 다음을 추가합니다.
``` js
require("jquery")
require("bootstrap-sprockets")
```
>app/views/layouts/application.html.haml 파일을 다음과같이 수정합니다.
``` haml
<!-- before -->
%body 
  - flash.each do |name, msg|
    = content_tag :div, msg, class: "alert alert-info"
    
  = yield
<!-- after -->
%body
  %nav.navbar.navbar-default
    .container
      .navbar-brand= link_to "Pin Board", root_path

      - if user_signed_in?
        %ul.nav.navbar-nav.navbar-right
          %li= link_to "New Pin", new_pin_path
          %li= link_to "Account", edit_user_registration_path
          %li= link_to "Sign Out", destroy_user_session_path, method: :delete
      - else
        %ul.nav.navbar-nav.navbar-right
          %li= link_to "Sign Up", new_user_registration_path
          %li= link_to "Sign In", new_user_session_path
  .container
    - flash.each do |name, msg|
      = content_tag :div, msg, class: "alert alert-info"
    
    = yield
```
>New Pin이 중복되는 것을 방지하기 위해 app/views/pins/index.html.haml 파일에서 다음을 삭제합니다.
``` haml
=link_to "New Pin", new_pin_path
```
>app/views/pins/new.html.haml 파일에 스타일을 적용시켜 줍니다.    
>app/views/pins/edit.html.haml 파일에 스타일을 적용시켜 줍니다.
``` haml
.col-md-6.col-md-offset-3
  %h1 New Form
  = render 'form'
  = link_to "Back", root_path
```
``` haml
.col-md-6.col-md-offset-3
  %h1 Edit Pin
  = render 'form'
  = link_to "Cancle", pin_path
```
>이미지를 적용하기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'paperclip', '~> 6.1'
```
``` terminal
$ sudo gem install paperclip
```
>paperclip을 사용하기 위해 app/models/pin.rb 파일에 다음을 추가해줍니다.    
>paperclip의 pin image를 생성하고 마이그레이션을 해줍니다.
``` rb
has_attached_file :image, styles: { medium: "300x300>" }
validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
```
``` terminal
$ sudo rails generate paperclip pin image
$ sudo rake db:migrate
```
>마이그레이션 실행 시 오류가 발생한다면 app/db/migrate 폴더에 add_attachment_image_to_pins.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
class AddAttachmentImageToPins < ActiveRecord::Migration
# after
class AddAttachmentImageToPins < ActiveRecord::Migration[6.0]
```
>app/views/pins/_form.html.haml 파일에 다음을 추가해줍니다.
``` haml
.form-group
  = f.input :image, input_html: { class: 'form-control' }
```
>Pin 생성 시 이미지를 저장할 수 있게 app/controllers/pins_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
params.require(:pin).permit(:title, :description)
# after
params.require(:pin).permit(:title, :description, :image)
```
>생성한 Pin의 이미지를 보기 위해 app/views/pins/show.html.haml 파일 최상단에 다음을 추가합니다.
``` haml
= image_tag @pin.image.url(:medium)
```
>Index 페이지에서 이미지를 볼 수 있게 app/views/pins/index.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to (image_tag pin.image.url(:medium)), pin
```
>수정하면서 이미지를 볼 수 있게 app/views/pins/edit.html.haml 파일에 다음을 추가합니다.
``` haml
= image_tag @pin.image.url(:medium)
```
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'masonry-rails', '~> 0.2.4'
```
``` terminal
$ sudo gem install masonry-rails
```
>app/javascript/packs/application.js 파일에 다음을 추가합니다.    
``` js
require("masonry/jquery.masonry")
```
>app/javascript/packs/폴더에 pins.coffee 파일을 추가하고 다음을 추가합니다.
``` coffee
$ ->
  $('#pins').imagesLoaded ->
    $('#pins').masonry
      itemSelector: '.box'
      isFitWidth: true
```
>javascript를 적용하기 위해 app/views/pins/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
- @pins.each do |pin|
  = link_to (image_tag pin.image.url(:medium)), pin
  %h2= link_to pin.title, pin
<!-- after -->
#pins.transitions-enabled
  - @pins.each do |pin|
    .box.panel.panel-default
      = link_to (image_tag pin.image.url), pin
      .panel-body
        %h2= link_to pin.title, pin
        %p.user
        Submitted by
        = pin.user.email
```
>스타일 적용을 위해 app/assets/stylesheets/application.scss 파일에 다음을 추가합니다.
``` scss
 *= require 'masonry/transitions'
 *= require 'masonry/basic'
body {
	background: #E9E9E9;
}

h1, h2, h3, h4, h5, h6 {
	font-weight: 100;
}

nav {
	box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.22);
	.navbar-brand {
		a {
			color: #BD1E23;
			font-weight: bold;
			&:hover {
				text-decoration: none;
			}
		}
	}
}

#pins {
  margin: 0 auto;
  width: 100%;
  .box {
	  margin: 10px;
	  width: 350px;
	  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.22);
	  border-radius: 7px;
	  text-align: center;
	  img {
	  	max-width: 100%;
	  	height: auto;
	  }
	  h2 {
	  	font-size: 22px;
	  	margin: 0;
	  	padding: 25px 10px;
	  	a {
				color: #474747;
	  	}
	  }
	  .user {
	  	font-size: 12px;
	  	border-top: 1px solid #EAEAEA;
			padding: 15px;
			margin: 0;
	  }
	}
}

#edit_page {
	.current_image {
		img {
			display: block;
			margin: 20px 0;
		}
	}
}

#pin_show {
	.panel-heading {
		padding: 0;
	}
	.pin_image {
		img {
			max-width: 100%;
			width: 100%;
			display: block;
			margin: 0 auto;
		}
	}
	.panel-body {
		padding: 35px;
		h1 {
			margin: 0 0 10px 0;
		}
		.description {
			color: #868686;
			line-height: 1.75;
			margin: 0;
		}
	}
	.panel-footer {
		padding: 20px 35px;
		p {
			margin: 0;
		}
		.user {
			padding-top: 8px;
		}
	}
}

textarea {
	min-height: 250px;
}
```
>masonry가 정상적으로 동작하지 않는다. 해결법을 찾지 못했으니 일단 넘어가자.    
>app/views/pins/show.html.haml 파일을 다음과 같이 수정한다.
``` haml
#pin_show.row
  .col-md-8.col-md-offset-2
    .panel.panel-default
      .panel-heading.pin_image
        = image_tag @pin.image.url
      .panel-body
        %h1= @pin.title
        %p= @pin.description
        %p
        Submitted by 
        =@pin.user.email
      .panel-footer
        .row
          .col-md-6
            %p.user
            Submitted by
            =@pin.user.email
          .col-md-6
            .btn-group.pull-right
              = link_to "Edit", edit_pin_path, class: "btn btn-default"
              = link_to "Delete", pin_path, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-default"
```
- 2020-11-03
>투표 기능을 추가하기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'acts_as_votable', '~> 0.12.1'
```
``` terminal
$ sudo gem install acts_as_votable
```
>acts_as_votable을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate acts_as_votable:migration
$ sudo rake db:migrate
```
>app/models/pin.rb 파일에 다음을 추가합니다.
``` rb
acts_as_votable
```
>config/routes.rb 파일을 다음과 같이 수정해줍니다.
``` rb
# before
resources :pins
# after
resources :pins do
  member do
    put "like", to: "pins#upvote"
  end
end
```
>app/contorllers/pins_controller.rb 파일을 다음과 같이 수정하고 추가해줍니다.
``` rb
# before
before_action :find_pin, only: [:show, :edit, :update, :destroy]
# after
before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
```
``` rb
def upvote
  @pin.upvote_by current_user
  redirect_back(fallback_location: root_path)
end
```
>app/views/pins/show.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
<!-- before -->
.btn-group.pull-right
  = link_to "Edit", edit_pin_path, class: "btn btn-default"
  = link_to "Delete", pin_path, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-default"
<!-- after -->
.btn-group.pull-right
  = link_to like_pin_path(@pin), method: :put, class: "btn btn-default" do
    %span.glyphicon.glyphicon-heart
      = @pin.get_upvotes.size
  - if user_signed_in?
    = link_to "Edit", edit_pin_path, class: "btn btn-default"
    = link_to "Delete", pin_path, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-default"
```
>로그인을 하지 않으면 index와 show 페이지만 볼 수 있게 하고 나머지 기능은 로그인을 해야 동작하게 하기위해 app/controllers/pins_controller.rb 파일에 다음을 추가합니다.
``` rb
before_action :authenticate_user!, except: [:index, :show]
```
>pin 생성 페이지를 바꿔주기 위해 app/views/pins/new.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
.col-md-6.col-md-offset-3
  .row
    .panel.panel-default
      .panel-heading
        %h1 New Pin
      .panel-body
        = render 'form'
```
>계정 수정 화면 디자인 적용을 위해 app/views/devise/registrations/edit.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<div class="col-md-6 col-md-offset-3">
  <div class="row">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h2>Edit Your Pin</h2>
      </div>

      <div class="panel-body">
        <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
          <%= f.error_notification %>

          <div class="form-group">
            <%= f.input :email, required: true, autofocus: true, input_html: {class: 'form-control' } %>
          </div>

          <div class="form-gruop">
            <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
              <p>Currently waiting confirmation for: <%= resource.unconfirmed_email %></p>
            <% end %>
          </div>

          <div class="form-group">
            <%= f.input :password,
                        hint: "leave it blank if you don't want to change it",
                        required: false,
                        input_html: { autocomplete: "new-password" },
                        input_html: {class: 'form-control' } %>
          </div>

          <div class="form-group">
            <%= f.input :password_confirmation,
                        required: false,
                        input_html: { autocomplete: "new-password" },
                        input_html: {class: 'form-control' } %>
          </div>

          <div class="form-group">
            <%= f.input :current_password,
                        hint: "we need your current password to confirm your changes",
                        required: true,
                        input_html: { autocomplete: "current-password" },
                        input_html: {class: 'form-control' } %>
          </div>

          <div class="form-actions">
            <%= f.button :submit, "Update", class: "btn btn-primary" %>
          </div>
        <% end %>
      </div>

      <div class="panel-footer">
        <h3>Cancel my account</h3>

        <p>Unhappy? <%= link_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete %></p>

        <%= link_to "Back", :back %>
      </div>
    </div>
  </div>
</div>
```
>pin의 수정 페이지를 바꾸기 위해 app/views/pins/edit.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
.col-md-6.col-md-offset-3
  .row
    .panel.panel-default
      .panel-heading
        %h1 Edit Pin
      .panel-body
        %strong.center Current Image
        %br
        = image_tag @pin.image.url(:medium)
        %br
        = render 'form'
```
>Sign Up 페이지를 바꾸기 위해 app/views/devise/registrations/new.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<div class="col-md-6 col-md-offset-3">
  <div class="row">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h2>Sign Up</h2>
      </div>
      <div class="panel-body">
        <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
          <%= f.error_notification %>

          <div class="form-inputs">
            <div class="form-group">
              <%= f.input :email,
                          required: true,
                          autofocus: true,
                          input_html: { autocomplete: "email" },
                          input_html: {class: 'form-control' } %>
            </div>
            <div class="form-group">
              <%= f.input :password,
                          required: true,
                          hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                          input_html: { autocomplete: "new-password" },
                          input_html: {class: 'form-control' } %>
            </div>
            <div class="form-group">
              <%= f.input :password_confirmation,
                          required: true,
                          input_html: { autocomplete: "new-password" },
                          input_html: {class: 'form-control' } %>
            </div>
          </div>

          <div class="form-actions">
            <%= f.button :submit, "Sign up", class: "btn btn-primary" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  </div>
</div>
```
>Sign In 페이지를 바꾸기 위해 app/views/devise/sessions/new.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<div class="col-md-6 col-md-offset-3">
  <div class="row">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h2>Sign In</h2>
      </div>

      <div class="panel-body">
        <%= simple_form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
          <div class="form-inputs">
            <%= f.input :email,
                        required: false,
                        autofocus: true,
                        input_html: { autocomplete: "email" } %>
            <%= f.input :password,
                        required: false,
                        input_html: { autocomplete: "current-password" } %>
            <%= f.input :remember_me, as: :boolean if devise_mapping.rememberable? %>
          </div>

          <div class="form-actions">
            <%= f.button :submit, "Log in", class: "btn btn-primary" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  </div>
</div>
```
---

## Moview Review
- 2020-11-08
>Moive를 생성하고 마이그레이션해줍니다.
``` terminal
$ sudo rails generate scaffold Movie title:string description:text movie_length:string director:string rating:string
$ sudo rake db:migrate
```
>User를 추가해주기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'devise', '~> 4.7', '>= 4.7.3'
```
``` terminal
$ sudo gem install devise
$ sudo rails generate devise:install
```
>config/environments/development.rb 파일에 다음을 추가해줍니다.
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>config/routes.rb 파일에 경로를 추가해줍니다.
``` rb
root 'movies#index'
```
>app/views/layouts/application.html.erb 파일에 다음을 추가해줍니다.
``` erb
<!-- before -->
<body>
  <%= yield %>
</body>
<!-- after -->
<body>
  <% flash.each do |name,msg| %>
    <%= content_tag(:div, msg, class: "alert alert-info") %>
  <% end %>
  <%= yield %>
</body>
```
>views를 생성하기위해 다음과 같이 입력해줍니다.    
>User를 생성하고 마이그레이션해줍니다.
``` terminal
$ sudo rails generate devise:views
```
``` terminal
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>movie에 user_id를 추가해줍니다.
``` terminal
$ sudo rails generate migration add_user_id_to_movies user_id:integer
$ sudo rake db:migrate
```
>로그인을 하지 않으면 index와 show만 볼 수 있도록 app/controllers/movies_controller.rb 파일을 수정해줍니다.
``` rb
before_action :authenticate_user!, except: [:index, :show]
# before
@movie = Movie.new
# 중략
@movie = Movie.new(movie_params)
# after
@movie = current_user.movies.build
# 중략
@movie = current_user.movies.build(movie_params)
```
>app/models/movie.rb 파일에 다음을 추가합니다.    
>app/models/user.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :user
```
``` rb
has_many :movies
```
>User_id 가 없는 Moive에 레일즈 콘솔을 이용해서 Update 해줍니다.
``` terminal
$ sudo rails c
$ @movie = Movie.first
$ @movie.user_id = 1
$ @movie.save
$ @movie = Movie.second
$ @movie.user_id = 1
$ @movie.save
```
>paperclip을 설치하기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'paperclip', '~> 6.1'
```
``` terminal
$ sudo gem install paperclip
```
>app/models/movie.rb 파일에 다음을 추가해줍니다.
``` rb
has_attached_file :image, styles: { medium: "400x600>" }
validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
```
>paperclip을 생성하고 마이그레이션해줍니다.
``` terminal
$ sudo rails generate paperclip movie image
$ sudo rake db:migrate
```
>app/controllers/movies_controller.rb 파일에 다음을 추가합니다.
``` rb
# before
params.require(:movie).permit(:title, :description, :movie_length, :director, :rating)
# after
params.require(:movie).permit(:title, :description, :movie_length, :director, :rating, :image)
```
>app/views/movies/_form.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<!-- before -->
</div>

<div class="actions">
<!-- after -->
</div>

<div class="field">
  <%= form.label :image %>
  <%= form.file_field :image %>
</div>

<div class="actions">
```
>app/views/movies/show.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<!-- before -->
<p id="notice"><%= notice %></p>
<!-- after -->
<%= image_tag @movie.image.url(:medium) %>
```
>app/views/movies/index.html.erb 파일에 다음을 추가합니다.
``` erb
<td><%= image_tag movie.image.url(:medium) %></td>
```
- 2020-11-09
>부트스트랩 스타일을 적용하기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'bootstrap-sass', '~> 3.4', '>= 3.4.1'
```
``` terminal
$ sudo gem install bootstrap-sass
```
>app/assets/stylesheets/application.css 파일을 application.scss 파일로 변경한 다음 다음을 추가해줍니다.
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>app/javascript/packs/application.js 파일에 다음을 추가해줍니다.
``` js
require("jquery")
require("bootstrap-sprockets")
```
>app/views/layouts/application.html.erb 파일을 다음과 같이 수정해줍니다.    
``` erb
<!-- before -->
<body>
  <% flash.each do |name,msg| %>
<!-- after -->
<body>
  <%= render 'layouts/header' %>
  <% flash.each do |name,msg| %>
```
>app/views/layouts/ 폴더에 _header.html.erb 파일을 추가하고 [다음](https://github.com/mackenziechild/movie_review/blob/master/app/views/layouts/_header.html.erb)을 추가합니다.    
>하단 form_tag 부분은 다음과 같이 수정해줍니다.
``` erb
<form class="navbar-form navbar-right" role="search">
  <div class="form-group">
    <input type="text" class="form-control" placeholder="Search">
  </div>
  <button type="submit" class="btn btn-default">Submit</button>
</form>
```
>app/views/movies/index.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<% if !user_signed_in? %>
  <div class="jumbotron">
    <h1>Your Favorite Movies Reviewed</h1>
    <p>Hashtag hoodie mumblecore selfies. Authentic keffiyeh leggings Kickstarter, narwhal jean shorts XOXO Vice Austin cardigan. Organic drinking vinegar freegan pickled.</p>
    <p><%= link_to "Sign Up To Write A Review", new_user_registration_path, class: "btn btn-primary btn-lg" %></p>
  </div>
<% end %>
<div class="row">
  <% @movies.each do |movie| %>
    <div class="col-sm-6 col-md-3">
      <div class="thumbnail">
        <%= link_to (image_tag movie.image.url(:medium), class: 'image'), movie %>
      </div>
    </div>
  <% end %>
</div>
```
>app/views/layouts/application.html.erb 파일에 다음을 추가합니다.
``` erb
<!-- before -->
<%= render 'layouts/header' %>
<% flash.each do |name,msg| %>
  <%= content_tag(:div, msg, class: "alert alert-info") %>
<% end %>
<%= yield %>
<!-- after -->
<%= render 'layouts/header' %>
<div class="container">
  <% flash.each do |name,msg| %>
    <%= content_tag(:div, msg, class: "alert alert-info") %>
  <% end %>
  <%= yield %>
</div>
```
>app/assets/stylesheets/scaffolds.scss 파일을 삭제합니다.    
>app/views/movies/show.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<div class="panel panel-default">
  <div class="panel-body">
    <div class="row">
      <div class="col-md-4">
        <%= image_tag @movie.image.url(:medium) %>
        <div class="table-responsive">
          <table class="table">
            <tbody>
              <tr>
                <td><strong>Title:</strong></td>
                <td><%= @movie.title %></td>
              </tr>
              <tr>
                <td><strong>Description:</strong></td>
                <td><%= @movie.description %></td>
              </tr>
              <tr>
                <td><strong>Movie length:</strong></td>
                <td><%= @movie.movie_length %></td>
              </tr>
              <tr>
                <td><strong>Director:</strong></td>
                <td><%= @movie.director %></td>
              </tr>
              <tr>
                <td><strong>Rating:</strong></td>
                <td><%= @movie.rating %></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<%= link_to 'Edit', edit_movie_path(@movie) %> |
<%= link_to 'Back', movies_path %>
```
>app/assets/stylesheets/application.scss 파일에 다음을 추가합니다.
``` scss
body {
	background: #AA4847;
}

.review_title {
	margin: 0 0 20px 0;
}
.reviews {
	padding: 15px 0;
	border-bottom: 1px solid #EAEAEA;
	.star-rating {
		padding-bottom: 8px;
	}
}
```
- 2020-11-10
>Review 스카폴드를 생성하고 마이그레이션해줍니다.
``` terminal
$ sudo rails generate scaffold Review rating:integer comment:text
$ sudo rake db:migrate
```
>review에 user_id를 추가하고 마이그레이션해줍니다.
``` terminal
$ sudo rails generate migration add_user_id_to_reviews user_id:integer
$ sudo rake db:migrate
```
>app/models/review.rb 파일에 다음을 추가합니다.    
>app/models/user.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :user
```
``` rb
has_many :reviews, dependent: :destroy
```
>app/controllers/reviews_controller.rb 파일에 다음을 추가해줍니다.
``` rb
before_action :authenticate_user!
# 중략
# @review = Review.new(review_params) 하단
@review.user_id = current_user.id
```
>app/views/reviews/ 폴더의 index.html.erb, index.json.jbuilder, show.html.erb, show.json.jbuilder를 삭제해줍니다.
- 2020-11-11
>movie에 review를 연결시켜줍니다.
``` terminal
$ sudo rails generate migration add_movie_id_to_reviews movie_id:integer
$ sudo rake db:migrate
```
>app/models/movie.rb 파일에 다음을 추가합니다.
``` rb
has_many :reviews
```
>app/models/review.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :movie
```
>app/views/reviews/_form.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<!-- before -->
<%= form_with(model: review, local: true) do |form| %>
<!-- after -->
<%= form_with(model: [ @movie, @review ], local: true) do |form| %>
```
>config/routes.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
resources :reviews
devise_for :users
resources :movies
# after
devise_for :users
  
resources :movies do
  resources :reviews, except: [:show, :index]
end
```
>app/controllers/reviews_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# 추가
before_action :set_movie
# 중략
# @review.user_id = current_user.id 하단
@review.movie_id = @movie.id
# 중략
# before
format.html { redirect_to @review, notice: 'Review was successfully created.' }
# after
format.html { redirect_to @movie, notice: 'Review was successfully created.' }
# 중략
# private의 set_review 하단
def set_movie
  @movie = Movie.find(params[:movie_id])
end
```
>app/views/reviews/new.html.erb 파일과 edit.html.erb 파일을 다음과 같이 수정합니다.    
``` erb
<!-- before -->
<%= link_to 'Back', reviews_path %>
<!-- after -->
<%= link_to 'Back', movie_path(@movie) %>
```
>app/views/movies/show.html.erb 파일을 다음을 추가합니다.
``` erb
<!-- 생략 -->
<!-- </table> 하단 -->
    <%= link_to "Write a Review", new_movie_review_path(@movie) %>
  </div>
</div>
<div class="col-md-7 col-md-offset-1">
  <h1 class="review_title"><%= @movie.title %></h1>
  <p><%= @movie.description %></p>

  <% if @reviews.blank? %>
    <h3>No reviews just yet, would you like to add the first!</h3>
    <%= link_to "Write Review", new_movie_review_path(@movie), class: "btn btn-danger" %>
  <% else %>
    <% @reviews.each do |review| %>
      <div class="reviews">
        <p><%= review.rating %></p>
        <p><%= review.comment %></p>
      </div>
    <% end %>
  <% end %>
</div>
```
>app/controllers/moviews_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
def show 
end
# after
def show
  @reviews = Review.where(movie_id: @movie.id).order("created_at DESC")
end
```
>app/assets/stylesheets/scaffolds.scss 파일을 삭제합니다.    
>app/views/movies/show.html.erb 파일을 다음과 같이 수정한다.
``` erb
<!-- before -->
<p><%= review.rating %></p>
<!-- after -->
<div class="star-rating" data-score= <%= review.rating %> ></div>
```
``` erb
<!-- 최하단 -->
<script>
  $('.star-rating').raty({
    path: '/assets/images',
    readOnly: true,
    score: function() {
      return $(this).attr('data-score');
    }
  });
</script>
```
>app/views/reviews/_form.html.erb 파일의 다음을 수정합니다.
``` erb
<!-- before -->
<<%= form.label :rating %>
    <%= form.number_field :rating %>>
<!-- after -->
<div id="star-rating"></div>
```
``` erb
<!-- 최하단 -->
<script>
  $('#star-rating').raty({
    path: '/assets/',
    scoreName: 'review[rating]'
  });
</script>
```
>app/javascript/packs/application.js 파일에 다음을 추가합니다.
``` js
require("jquery.raty")
```
``` js
// 최하단
//= require jquery.raty
```
>raty가 정상 동작하지 않아 4시간 가량 찾아봤으나 해결하지 못하였다.    
>app/controllers/movies_controller.rb 파일에 다음을 추가합니다.
``` rb
# def show
#   @reviews ...
    if @review.blank?
      @avg_review = 0
    else
      @avg_review = @reviews.average(:rating).round(2)
    end
```
>app/views/movies/show.html.erb 파일에 다음을 추가합니다.
``` erb
<!-- 생략 -->
<%= image_tag @movie.image.url(:medium) %>
<div class="star-rating" data-score= <%= @avg_review %>></div>
<em><%= "#{@reviews.length} reviews" %></em>
```
- 2020-11-12
>Xcode 버전 문제로 movie_review를 더이상 진행할 수 없어서 해당 프로젝트는 일시 중단합니다.
---

## Todo
- 2020-11-16
>todo_list 스카폴드를 다음과 같이 만들어줍니다.
``` terminal
$ sudo rails generate scaffold todo_list title:string description:text
$ sudo rake db:migrate
```
>config/routes.rb 파일을 수정하여 todo_lists를 index 페이지로 바꿔줍니다.
``` rb
root "todo_lists#index"
```
>모델을 생성해줍니다.
``` terminal
$ sudo rails generate model todo_item content:string todo_list:references
$ sudo rake db:migrate
```
>모델을 연결해 주기 위해 app/models/todo_list.rb 파일에 다음을 추가해줍니다.    
>config/routes.rb 파일을 다음과 같이 수정해줍니다.
``` rb
has_many :todo_items
```
``` rb
# before
resources :todo_lists
# after
resources :todo_lists do
  resources :todo_items
end
```
>컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate controller todo_items
```
>app/controllers/todo_items_controller.rb 파일에 다음을 추가해줍니다.
``` rb
before_action :set_todo_list

def create
  @todo_item = @todo_list.todo_items.create(todo_item_params)

  redirect_to @todo_list
end

private

def set_todo_list
  @todo_list = TodoList.find(params[:todo_list_id])
end

def todo_item_params
  params[:todo_item].permit(:content)
end
```
>app/views/todo_items/_form.html.erb 파일을 생성하고 다음을 추가합니다.    
>app/views/todo_items/_todo_item.html.erb 파일을 생성하고 다음을 추가합니다.
``` erb
<%= form_for([@todo_list, @todo_list.todo_items.build]) do |f| %>
  <%= f.text_field :content, placeholder: "New Todo" %>
  <%= f.submit %>
<% end %>
```
``` erb
<p><%= todo_item.content %></p>
```
>app/views/todo_lists/show.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<div id="todo_items_wrapper">
  <%= render @todo_list.todo_items %>
  <div id="form">
    <%= render "todo_items/form" %>
  </div>
</div>
<!-- <%= link_to 'Edit'... -->
```
>app/views/todo_items>_todo_item.html.erb 파일에 다음을 추가해줍니다.
``` erb
<%= link_to "Delete", todo_list_todo_item_path(@todo_list, todo_item.id), method: :delete, data: { confirm: "Are you sure?" } %>
```
>app/controllers/todo_items_controller.rb 파일에 다음을 추가합니다.
``` rb
def destory
  @todo_item = @todo_list.todo_items.find(params[:id])
  if @todo_item.destory
    flash[:success] = "Todo List item was deleted."
  else
    flash[:error] = "Todo List item could not be deleted."
  end
  redirect_to @todo_list
end
```
- 2020-11-17
>시간을 표시하기위해 다음과 같이 마이그레이션해줍니다.
``` terminal
$ sudo rails generate migration add_completed_at_to_todo_items completed_at:datetime
$ sudo rake db:migrate
```
>config/routes.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
resources :todo_items
# after
resources :todo_items do
  member do
    patch :complete
  end
end
```
>app/views/todo_items/_todo_item.html.erb 파일에 다음을 추가해줍니다.
``` erb
<%= link_to "Mark as Complete", complete_todo_list_todo_item_path(@todo_list, todo_item.id), method: :patch %>
```
>app/controllers/todo_items_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before 
before_action :set_todo_list
# after
before_action :set_todo_list
before_action :set_todo_item, except: [:create]
# 중략
# before
def destroy
  @todo_item = @todo_list.todo_items.find(params[:id])
  if @todo_item.destroy
# after
def destroy
  if @todo_item.destroy
# 중략
def complete
  @todo_item.update_attribute(:completed_at, Time.now)
  redirect_to @todo_list, notice: "Todo item completed"
end
# 중략
def set_todo_item
  @todo_item = @todo_list.todo_items.find(params[:id])
end
```
>app/views/todo_items/_todo_item.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<div class="row clearfix">
  <% if todo_item.completed? %>
    <div class="complete">
      <%= link_to "Mark as Complete", complete_todo_list_todo_item_path(@todo_list, todo_item.id), method: :patch %>
    </div>
    <div class="todo_item">
      <p style="opacity: 0.4;"><strike><%= todo_item.content %></strike></p>
    </div>
    <div class="trash">
      <%= link_to "Delete", todo_list_todo_item_path(@todo_list, todo_item.id), method: :delete, data: { confirm: "Are you sure?" } %>
    </div>
    <% else %>
      <div class="complete">
        <%= link_to "Mark as Complete", complete_todo_list_todo_item_path(@todo_list, todo_item.id), method: :patch %>
      </div>
      <div class="todo_item">
        <p><%= todo_item.content %></p>
      </div>
      <div class="trash">
        <%= link_to "Delete", todo_list_todo_item_path(@todo_list, todo_item.id), method: :delete, data: { confirm: "Are you sure?" } %>
      </div>
    <% end %>
</div>
```
>app/models/todo_item.rb 파일에 다음을 추가해줍니다.
``` rb
def completed?
  !completed_at.blank?
end
```
- 2020-11-18
>app/assets/stylesheets/application.css 파일을 application.scss로 바꿔주고, 나머지 scss 파일은 삭제한다.    
>[여기](https://github.com/mackenziechild/Todo-App/blob/master/app/assets/stylesheets/application.css.scss)에서 복사해서 app/assets/stylesheets/application.scss 파일에 붙여넣는다.    
>app/views/layouts/application.html.erb 파일에 다음을 추가한다.
``` erb
<div class="container">
  <%= yield %>
</div>
```
>app/views/todo_lists/index.html.erb 파일을 다음과 같이 바꿔줍니다.
``` erb
<% @todo_lists.each do |todo_list| %>
  <div class="index_row clearfix">
    <h2 class="todo_list_title"><%= link_to todo_list.title, todo_list %></h2>
    <p class="todo_list_sub_title"><%= todo_list.description %></p>
  </h2>
<% end %>

<div class="links">
  <%= link_to "New Todo List", new_todo_list_path %>
</div>
```
>app/views/layouts/application.html.erb 파일에 다음을 추가합니다.
``` erb
<link href='http://fonts.googleapis.com/css?family=Lato:300,400,700' rel='stylesheet' type='text/css'>
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
```
>app/views/todo_items/_todo_item.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<!-- before -->
<%= link_to "Mark as Complete", complete_todo_list_todo_item_path(@todo_list, todo_item.id), method: :patch %>
<!-- 중략 -->
<%= link_to "Delete", todo_list_todo_item_path(@todo_list, todo_item.id), method: :delete, data: { confirm: "Are you sure?" } %>
<!-- 중략 -->
<%= link_to "Mark as Complete", complete_todo_list_todo_item_path(@todo_list, todo_item.id), method: :patch %>
<!-- 중략 -->
<%= link_to "Delete", todo_list_todo_item_path(@todo_list, todo_item.id), method: :delete, data: { confirm: "Are you sure?" } %>
<!-- after -->
<%= link_to complete_todo_list_todo_item_path(@todo_list, todo_item.id), method: :patch do %>
  <i style="opacity: 0.4;" class="fa fa-check"></i>
<% end %>
<!-- 중략 -->
<%= link_to todo_list_todo_item_path(@todo_list, todo_item.id), method: :delete, data: { confirm: "Are you sure?" } do %>
  <i class="fa fa-trash"></i>
<% end %>
<!-- 중략 -->
<%= link_to complete_todo_list_todo_item_path(@todo_list, todo_item.id), method: :patch do %>
  <i class="fa fa-check"></i>
<% end %>
<!-- 중략 -->
<%= link_to todo_list_todo_item_path(@todo_list, todo_item.id), method: :delete, data: { confirm: "Are you sure?" } do %>
  <i class="fa fa-trash"></i>
<% end %>
```
>app/views/todo_lists/show.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<p id="notice"><%= notice %></p>

<h2 class="todo_list_title"><%= @todo_list.title %></h2>
<p class="todo_list_sub_title"><%= @todo_list.description %></p>

<div id="todo_items_wrapper">
  <%= render @todo_list.todo_items %>
  <div id="form">
    <%= render "todo_items/form" %>
  </div>
</div>

<div class="links">
  <%= link_to 'Edit', edit_todo_list_path(@todo_list) %> |
  <%= link_to 'Delete', todo_list_path(@todo_list), method: :delete, data: { confirm: "Are you sure?" } %> |
  <%= link_to 'Back', todo_lists_path %>
</div>
```
>app/controllers/todo_lists_controller.rb 파일의 다음을 수정합니다.
``` rb
# before
format.html { redirect_to todo_lists_url, notice: 'Todo list was successfully destroyed.' }
# after
format.html { redirect_to root_url, notice: 'Todo list was successfully destroyed.' }
```
>app/views/todo_lists>new.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<h1 class="todo_list_title">New Todo List</h1>

<div class="forms">
  <%= render 'form', todo_list: @todo_list %>
</div>

<div class="links">
  <%= link_to 'Back', todo_lists_path %>
</div>
```
>app/views/todo_lists/edit.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<h1 class="todo_list_title">Editing Todo List</h1>

<div class="forms">
  <%= render 'form', todo_list: @todo_list %>
</div>

<div class="links">
  <%= link_to 'Cancle', todo_lists_path %>
</div>
```
---

## Jobs-Board
- 2020-11-20
>job 모델을 생성하고 마이그레이션합니다.
``` terminal
$ sudo rails generate model job title:string description:text company:string url:string
$ sudo rake db:migrate
```
>jobs 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate controller jobs
```
>app/controllers/jobs_controller.rb 파일에 다음을 추가해줍니다.
``` rb
def index
end
```
>config/routes.rb 파일에 다음을 추가해줍니다.
``` rb
resources :jobs
root 'jobs#index'
```
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'simple_form', '~> 5.0', '>= 5.0.3'
gem 'haml', '~> 5.2'
gem 'bootstrap-sass', '~> 3.4', '>= 3.4.1'
```
``` terminal
$ sudo gem install simple_form
$ sudo gem install haml
$ sudo gem install bootstrap-sass
```
>app/assets/stylesheets/application.css 파일을 application.scss 파일로 바꾸고 다음을 추가합니다.
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>app/javascript/packs/application.js 파일에 다음을 추가해줍니다.
``` js
require("bootstrap-sprockets")
```
>simple_form을 bootstrap을 이용하여 설치해줍니다.
``` terminal
$ sudo rails generate simple_form:install --bootstrap
```
>app/views/jobs/index.html.haml을 생성하고 다음을 추가합니다.
``` haml
%h1 This is INDEX page
```
>app/controllers/jobs_controller.rb 파일에 다음을 추가합니다.
``` rb
class JobsController < ApplicationController
  before_action :find_job, only: [:show, :edit, :update, :destroy]
  def index
  end

  def show
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(jobs_params)

    if @job.save
      redirect_to @job
    else
      render "New"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def jobs_params
    params.require(:job).permit(:title, :description, :company, :url)
  end

  def find_job
    @job = Job.find(params[:id])
  end

end
```
>app/views/jobs/new.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 New Job

= render 'form'

= link_to "Back", root_path
```
>app/views/jobs/_form.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
= simple_form_for(@job, html: { class: 'form-horizontal' }) do |f|
  = f.input :title, label: "Job Title"
  = f.input :description, label: "Job Description"
  = f.input :company, label: "Your Company"
  = f.input :url, label: "Link to Job"
  %br
  = f.button :submit
```
>app/views/jobs/show.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1= @job.title
%p= @job.description
%p= @job.company

= link_to "Home", root_path
```
>app/controllers/jobs_controller.rb 파일의 index에 다음을 추가합니다.
``` rb
def index
  @jobs = Job.all.order("created_at DESC")
end
```
>app/views/jobs/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
- @jobs.each do |job|
  %h2= job.title
  %p= job.company

= link_to "New Job", new_job_path
```
>app/controllers/jobs_controller.rb 파일에 update와 destroy를 수정합니다.
``` rb
def update
  if @job.update(jobs_params)
    redirect_to @job
  else
    render "Edit"
  end
end

def destroy
  @job.destroy
  redirect_to root_path
end
```
>app/views/jobs/show.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to "Edit", edit_job_path(@job)
```
>app/views/jobs/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
%h2= job.title
<!-- after -->
%h2= link_to job.title, job
```
>app/views/jobs/edit.html.haml 파일을 만들고 다음을 추가합니다.
``` haml
%h1 Edit Job

= render 'form'

= link_to "Back", root_path
```
>app/views/jobs/show.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to "Delete", job_path(@job), method: :delete, data: { confirm: "Are you sure?" }
```
- 2020-11-21
>category 모델을 생성하고 마이그레이션합니다.
``` terminal
$ sudo rails generate model category name:string
$ sudo rake db:migrate
```
>jobs에 category를 추가해줍니다.
``` terminal
$ sudo rails generate migration add_category_id_to_jobs category_id:integer
$ sudo rake db:migrate
```
>app/models/job.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :category
```
>app/models/category.rb 파일에 다음을 추가합니다.
``` rb
has_many :jobs
```
>레일즈 콘솔을 이용해 카테고리를 생성해줍니다.
``` terminal
> Category.create(name: "Full Time")
> Category.create(name: "Part Time")
> Category.create(name: "Freelance")
> Category.create(name: "Consulting")
```
>app/views/jobs/_form.html.haml 파일에 다음을 추가해줍니다.
``` haml
= f.collection_select :category_id, Category.all, :id, :name, { promt: "Choose a category" }
```
>app/controllers/jobs_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
params.require(:job).permit(:title, :description, :company, :url)
# after
params.require(:job).permit(:title, :description, :company, :url, :category_id)
```
>app/views/layouts/application.html.erb 파일을 application.html.haml 파일로 변경하고 다음과 같이 수정합니다.
``` haml
!!!
%html
%head
  %title Ruby on Rails Jobs
  = csrf_meta_tags
  = csp_meta_tag

  = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
  = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'

%body
  - Category.all.each do |category|
    = link_to category.name, jobs_path(category: category.name)
  = yield
```
>app/controllers/jobs_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
def index
  if params[:category].blank?
    @jobs = Job.all.order("created_at DESC")
  else
    @category_id = Category.find_by(name: params[:category]).id
    @jobs = Job.where(category_id: @category_id).order("created_at DESC")
  end
end
```
- 2020-11-22
>app/views/layouts/application.html.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- brfore -->
%body
  - Category.all.each do |category|
    %li= link_to category.name, jobs_path(category: category.name)
  = yield
<!-- after -->
%body
  %nav.navbar.navbar-default
    .container
      .navbar-brand Rails Jobs
      %ul.nav.navbar-nav
        %li= link_to "All Jobs", root_path
        - Category.all.each do |category|
          %li= link_to category.name, jobs_path(category: category.name)
      = link_to "New Job", new_job_path, class: "navbar-text navbar-right navbar-link"
  .container
    .col-md-6.col-md-offset-3
      = yield
```
>app/assets/stylesheets/application.scss 파일에 [다음](https://github.com/mackenziechild/jobs_board/blob/master/app/assets/stylesheets/application.css.scss)을 복사하여 붙여넣어줍니다.    
>index 페이지 스타일링을 위해 app/views/jobs/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
#jobs
  - @jobs.each do |job|
    .job
      %h2= link_to job.title, job
      %p= job.company
```
>app/views/jobs/show.html.haml 파일을 다음과 같이 수정합니다.
``` haml
#jobs
  .job
    %h2= @job.title
    %p= @job.description
    %p= @job.company
    %button.btn.btn-default= link_to "Apply for Job", @job.url

#links
  = link_to "Back", root_path, class: "btn btn-sm btn-default"
  = link_to "Edit", edit_job_path(@job), class: "btn btn-sm btn-default"
  = link_to "Delete", job_path(@job), method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-sm btn-default"
```
>app/views/jobs/_form.html.haml 파일은 수정하지 않아도 된다.
---

## Workout Log
- 2020-11-23
>workout 모델을 생성하고 마이그레이션해줍니다.
``` terminal
$ sudo rails generate model workout date:datetime workout:string mood:string length:string
$ sudo rake db:migrate
```
>workouts 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate controller workouts
```
>workouts의 경로를 index 페이지로 변경하기위해 config/routes.rb 파일에 다음을 추가합니다.
``` rb
resources :workouts
root 'workouts#index'
```
>app/controllers/workouts_controller.rb 파일에 다음을 추가합니다.
``` rb
def index
end
```
- 2020-11-24
>Genfile에 다음을 추가하여 haml,simple_form, bootstrap-sass를 설치합니다.
``` terminal
$ sudo gem install haml
$ sudo gem install simple_form
$ sudo gem install bootstrap-sass
```
>app/assets/stylesheets/application.css 파일을 application.scss 파일로 변경하고 다음을 추가합니다.
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>app/javascript/packs/application.js 파일에 다음을 추가합니다.
``` js
require("jquery")
require("bootstrap-sprocket")
```
>simple_form을 사용하기위해 설치해줍니다.
``` terminal
$ sudo rails generate simple_form:install --bootstrap
```
>index 페이지가 잘 동작하는지 확인하기 위해 app/views/workouts/index.html.haml 파일을 생성하여 다음을 추가합니다.
``` haml
%h1 This is the Workouts#Index Placeholder
```
>app/controllers/workouts_controller.rb 파일에 다음을 추가합니다.
``` rb
before_action :find_workout, only: [:show, :edit, :update, :destroy]
def show
end

def new
  @workout = Workout.new
end

def create
  @workout = Workout.new(workout_params)
  if @workout.save
    redirect_to @workout
  else
    render 'new'
  end
end

def edit
end

def update
end

def destroy
end

private

def workout_params
  params.require(:workout).permit(:date, :workout, :mood, :length)
end

def find_workout
  @workout = Workout.find(params[:id])
end
```
>app/views/workouts/_form.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
= simple_form_for(@workout, html: { class: 'form-horizontal' }) do |f|
  = f.input :date, label: "Date"
  = f.input :workout, label: "What area did you workout"
  = f.input :mood, label: "How were you feeling?"
  = f.input :length, label: "How long was the workout?"
  %br
  = f.button :submit
```
>app/views/workouts/new.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 New Workout

= render 'form'

= link_to "Cancle", root_path
```
>app/views/workouts/show.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
#workout
  %p= @workout.date
  %p= @workout.workout
  %p= @workout.mood
  %p= @workout.length
```
- 2020-11-26
>index 페이지에 workout을 표시하기 위하여 app/views/workouts/index.html.haml 파일에 다음과 같이 수정합니다.
``` haml
- @workouts.each do |workout|
  %h2= link_to workout.date, workouts_path
  %h3= workout.workout
```
>app/controllers/workouts_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
def index
end
# after
def index
  @workouts = Workout.all.order("created_at DESC")
end
```
- 2020-11-27
>app/controllers/workouts_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
def update
end

def destroy
end
# after
def update
  if @workout.update(workout_params)
    redirect_to @workout
  else
    render 'edit'
  end
end

def destroy
  @workout.destroy
  redirect_to root_path
end
```
>app/views/workouts/show.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to "Back", root_path
| 
= link_to "Edit", edit_workout_path(@workout)
|
= link_to "Delete", workout_path(@workout), method: :delete, data: { confirm: "Are you sure?" }
```
>app/views/workouts/edit.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 Edit Workout

= render 'form'

= link_to "Cancle", root_path
```
>app/views/layouts/application.html.erb 파일을 application.html.haml 파일로 변경하고 다음과 같이 수정합니다.
``` haml
!!!
%html
%head
  %title Workout Log Application
  = csrf_meta_tags
  = csp_meta_tag

  = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
  = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'
%body
  %nav.navbar.navbar-default
    .container
      .navbar-header
        = link_to "Workout Log", root_path, class: "navbar-brand"
      .nav.navbar-nav.navbar-right
        = link_to "New Workout", new_workout_path, class: "navbar navbar-link"
  .container
    = yield
```
- 2020-11-28
>exercise 모델을 생성하고 마이그레이션해줍니다.
``` terminal
$ sudo rails generate model exercise name:string sets:integer reps:integer workout:references
$ sudo rake db:migrate
```
>app/models/workout.rb 파일에 다음을 추가해줍니다.
``` rb
has_many :exercises, dependent: :destroy
```
>config/routes.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
resources :workouts
# after
resources :workouts do
  resources :exercises
end
```
>exercises 컨트롤러를 생성합니다.
``` terminal
$ sudo rails generate controller exercises
```
>app/controllers/exercises_controller.rb 파일에 다음을 추가합니다.
``` rb
def create
  @workout = Workout.find(params[:workout_id])
  @exercise = @workout.exercises.create(params[:exercise].permit(:name, :sets, :reps))

  redirect_to workout_path(@workout)
end
```
>app/views/exercises/_form.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
= simple_form_for([@workout, @workout.exercises.build]) do |f|
  = f.input :name
  = f.input :sets
  = f.input :reps
  %br
  = f.button :submit
```
>app/views/exercises/_exercise.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%p= exercise.name
%p= exercise.sets
%p= exercise.reps
```
>app/views/workouts/show.html.haml 파일에 다음을 추가합니다.
``` haml
#exercises
  %h2 Exercises
  = render @workout.exercises

  %h3 Add an exercise
  = render "exercises/form"
```
- 2020-11-29
>app/views/workouts/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
%h2= link_to workout.date, workout
<!-- after -->
#index_workouts
  - @workouts.each do |workout|
    %h2= link_to workout.date.strftime("%A %B %d"), workout
    %h3
      %span Workout: 
      = workout.workout
```
>[여기](uigradients.com)에서 원하는 배경의 css 코드를 복사하여 app/assets/stylesheets/application.scss 파일에 추가하고 다음을 추가합니다.
``` scss
body {
  /* code here */
}

.navbar-default {
  background: rgba(250, 250, 250, 0.5);
  -webkit-box-shadow: 0 1px 1px 0 rgba(0,0,0,.2);
  box-shadow: 0 1px 1px 0 rgba(0,0,0,2);
  border: none;
  border-radius: 0;
  .navbar-header {
    .navbar-brand {
      color: white;
      font-size: 20px;
      text-transform: uppercase;
      font-weight: 700;
      letter-spacing: -1px;
    }
  }
  .navbar-link {
    line-height: 3.5;
    color: rgb(158, 78, 98);
  }
}

#index_workouts {
  h2 {
    margin-bottom: 0;
    font-weight: 100;
    a {
      color: white;
    }
  }
  h3 {
    margin: 0;
    font-size: 18px;
    span {
      color: rgb(158, 78, 98);
    }
  }
}
```
>app/views/layouts/application.html.haml 파일의 다음을 수정합니다.
``` haml
<!-- before -->
= link_to "New Workout", new_workout_path, class: "navber navbar-link"
<!-- after -->
= link_to "New Workout", new_workout_path, class: "navbar-link"
```
---

## Wikipedia Clone
- 2020-11-30
>레일즈 프로젝트를 생성합니다.
``` terminal
$ sudo rails new wiki
```
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'haml', '~> 5.2'
gem 'bootstrap-sass', '~> 3.4', '>= 3.4.1'
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'simple_form', '~> 5.0', '>= 5.0.3'
```
``` terminal
$ sudo gem install haml
$ sudo gem install bootstrap-sass
$ sudo gem install devise
$ sudo gem install simple_form
```
>Article 모델과 컨트롤러를 생성하고 마이그레이션합니다.
``` terminal
$ sudo rails generate model Article title:string content:text
$ sudo rails generate controller Articles
$ sudo rake db:migrate
```
>app/controllers/articles_controller.rb 파일에 다음을 추가합니다.
``` rb
def index
end

def new
  @article = Article.new
end

def create
  @article = Article.new(article_params)
  if @article.save
    redirect_to @article
  else
    render 'new'
  end
end

private

def article_params
  params.require(:article).permit(:title, :content)
end
```
>config/routes.rb 파일에 다음을 추가합니다.
``` rb
resources :articles
root 'articles#index'
```
>app/views/articles/index.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 This is the articles#index placeholder
```
>app/views/articles/_form.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
= simple_form_for @article do |f|
  = f.input :title
  = f.input :content
  = f.submit
```
>app/views/articles/new.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 New Article

= render 'form'

= link_to "Back", root_path
```
>simple_form을 bootstrap 옵션을 추가하여 설치해줍니다.
``` terminal
$ sudo rails generate simple_form:install --bootstrap
```
>app/controllers/articles_controller.rb 파일에 다음을 추가합니다.
``` rb
before_action :find_article, only: [:show]
# 중략
def show
end
# 중략
def find_article
  @article = Article.find(parmas[:id])
end
```
>app/views/articles/show.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1= @article.title
%p= @article.content

= link_to "Back", root_path
```
>app/views/articles/index.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to "New Article", new_article_path
```
- 2020-12-01
>app/views/articles/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
%h1 This is the articles#index placeholder

= link_to "New Article", new_article_path
<!-- after -->
- @articles.each do |article|
  %h2= article.title
  %p
    Published at
    = article.created_at.strftime('%b %d, %Y')
  %p= truncate(article.content, length: 200)

= link_to "New Article", new_article_path
```
>app/controllers/articles_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
def index
end
# after
def index
  @articles = Article.all.order("created_at DESC")
end
```
>devise를 설치해줍니다.
``` terminal
$ sudo rails generate devise:install
```
>config/environments>development.rb 파일에 다음을 추가합니다.
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>app/views/layouts/application.html.erb 파일에 다음을 추가합니다.
``` erb
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```
>devise의 views를 생성해줍니다.    
>devise의 User를 생성해줍니다.    
>마이그레이션 해줍니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>app/models/article.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :user
```
>app/models/user.rb 파일에 다음을 추가합니다.
``` rb
has_many :articles
```
>user_id를 articles에 추가하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate migration add_user_id_to_articles user_id:integer:index
$ sudo rake db:migrate
```
>app/controllers/articles_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
@article = Article.new
# 중략
@article = Article.new(article_params)
# after
@article = current_user.articles.build
# 중략
@article = current_user.articles.build(article_params)
```
- 2020-12-02
>app/controllers/articles_controller.rb 파일에 다음을 추가합니다.
``` rb
before_action :authenticate_user!, except: [:index, :show]
```
>app/views/articles/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
= link_to "New Article", new_article_path
<!-- after -->
- if user_signed_in?
  = link_to "New Article", new_article_path
```
>Category 모델을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model Category name:string
$ sudo rake db:migrate
```
>category를 article에 연결합니다.
``` terminal
$ sudo rails generate migration add_category_id_to_articles category_id:integer
```
>app/models/article.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :category
```
>app/models/category.rb 파일에 다음을 추가합니다.
``` rb
has_many :articles
```
>rails 콘솔에서 카테고리를 생성해줍니다.
``` terminal
> Category.create(name: "Art")
> Category.create(name: "Technology")
> Category.create(name: "Politics")
```
>app/views/articles/_form.html.haml 파일에 다음을 추가합니다.
``` haml
= f.collection_select :category_id, Category.all, :id, :name, { promt: "Choose a Category" }
```
>app/controllers/articles_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
params.require(:article).permit(:title, :content)
# after
params.require(:article).permit(:title, :content, :category_id)
```
>app/views/layouts/application.html.erb 파일을 application.html.haml 파일로 바꾸고 다음과 같이 수정해줍니다.
``` haml
!!!
%html
  %head
    %title Wiki
    = csrf_meta_tags
    = csp_meta_tag

    = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'
  %body
    %p.notice= notice
    %p.alert= alert

    = yield

    %ul
      %li= link_to "All Articles", root_path
      - Category.all.each do |category|
        %li= link_to category.name, articles_path(category: category.name)
```
>app/controllers/articles_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
@articles = Article.all.order("created_at DESC")
# after
if params[:category].blank?
  @articles = Article.all.order("created_at DESC")
else
  @category_id = Category.find_by(name: params[:category]).id
  @articles = Article.where(category_id: @category_id).order("created_at DESC")
end
```
>app/views/articles/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
%h2= article.title
<!-- after -->
%h2= link_to article.title, article
```
>app/controllers/articles_controller.rb 파일을 다음과 같이 수정하고 추가합니다.
``` rb
# before
before_action :find_article, only: [:show]
# after
before_action :find_article, only: [:show, :edit, :update, :destroy]
```
``` rb
def edit
end

def update
  if @article.update(article_params)
    redirect_to @article
  else
    render 'edit'
  end
end

def destroy
  @article.destroy
  redirect_to root_path
end
```
>app/views/articles/show.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to "Edit", edit_article_path(@article)
= link_to "Delete", article_path(@article), method: :delete, data: { confirm: "Are you sure?" }
```
>app/views/articles/edit.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
%h1 Edit Article

= render 'form'

= link_to "Back", root_path
```
- 2020-12-04
>app/assets/styleshhets/application.css 파일을 application.scss 파일로 바꾸고 다음을 추가합니다.
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";

ul {
  list-style: none;
}
```
>jQuery를 사용하기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'jquery-rails'
```
``` terminal
$ sudo bundle install
```
>app/javascript/packs/application.js 파일에 다음을 추가합니다.
``` js
require("jquery")
require("bootstrap-sprockets")
```
>app/views/layouts/application.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
%body
  %nav.navbar.navbar-default.navbar-fixed-top
    .container
      = link_to "Wiki", root_path, class: "navbar-brand"
      %ul.nav.navbar-nav.navbar-right
        - if user_signed_in?
          %li= link_to "New Article", new_article_path
  %p.notice= notice
  %p.alert= alert

  .container
    .row
      .col-md-8
        = yield
      .col-md-4
        %ul.list-group
          %li= link_to "All Articles", root_path, class: "list-group-item"
          - Category.all.each do |category|
            %li= link_to category.name, articles_path(category: category.name), class: "list-group-item"
```
>app/views/articles/show.html.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
= link_to "Back", root_path
= link_to "Edit", edit_article_path(@article)
= link_to "Delete", article_path(@article), method: :delete, data: { confirm: "Are you sure?" }
<!-- after -->
.btn-group
  = link_to "Back", root_path, class: "btn btn-default"
  - if user_signed_in?
    = link_to "Edit", edit_article_path(@article), class: "btn btn-default"
    = link_to "Delete", article_path(@article), method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
```
>app/views/articles/index.html.haml 파일에 다음을 삭제해줍니다.
``` haml
- if user_signed_in?
  = link_to "New Article", new_article_path
```
---

## Forum
- 2020-12-05
>post 모델을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model post title:string content:text
$ sudo rake db:migrate
```
>post 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate controller posts
```
>app/controllers/posts_controller.rb 파일에 다음을 추가합니다.
``` rb
def index
end
```
>config/routes.rb 파일에 다음을 추가합니다.
``` rb
resources :posts

root 'posts#index'
```
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'haml', '~> 5.2', '>= 5.2.1'
gem 'simple_form', '~> 5.0', '>= 5.0.3'
gem 'devise', '~> 4.7', '>= 4.7.3'
```
``` terminal
$ sudo bundle install
```
>app/views/posts/index.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 This is the index placeholder text
```
>app/controllers/posts_controller.rb 파일에 다음을 추가해줍니다.
``` rb
before_action :find_post, only: [:show, :edit, :update, :destroy]

def index
end

def show
end

def new
  @post = Post.new
end

def create
  @post = Post.new(post_params)

  if @post.save
    redirect_to @post
  else
    render 'new'
  end
end

def edit
end

def update
  if @post.update(post_params)
    redirect_to @post
  else
    render 'edit'
  end
end

def destroy
  @post.destroy
  redirect_to root_path
end

private

def find_post
  @post = Post.find(params[:id])
end

def post_params
  params.require(:post).permit(:title, :content)
end
```
>app/views/posts/_form.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
= simple_form_for @post do |f|
  = f.input :title
  = f.input :content
  = f.submit
```
>app/views/posts/new.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 New Post

= render 'form'

= link_to "Back", root_path
```
>app/views/posts/show.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
%h1= @post.title
%p= @post.content

= link_to "Edit", edit_post_path(@post)
= link_to "Delete", post_path(@post), method: :delete, data: { confirm: "Are you sure you wnat to do this?" }
= link_to "Home", root_path
```
>app/views/posts/edit.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 Edit Post

= render 'form'

= link_to "Cancle", post_path
```
- 2020-12-07
>app/controllers/posts_controller.rb 파일의 다음을 수정해줍니다.
``` rb
# before
def index
end
# after
def index
  @posts = Post.all.order("created_at DESC")
end
```
>app/views/posts/index.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
- @posts.each do |post|
  %h2= post.title
  %p
    Published at
    = time_ago_in_words(post.created_at)

= link_to "New Post", new_post_path
```
>app/views/posts/index.html.haml 파일에 다음을 추가해줍니다.
``` haml
<!-- before -->
%h2= post.title
<!-- after -->
%h2= link_to post.title, post
```
>devise를 사용하기위해 설치해줍니다.
``` terminal
$ sudo rails generate devise:install
```
>config/environments/development.rb 파일에 다음을 추가합니다.
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>app/views/layouts/application.html.erb 파일을 application.html.haml 파일로 바꾸고 다음처럼 수정해줍니다.
``` haml
!!!
%html
  %head
    %title Forum
    = csrf_meta_tags
    = csp_meta_tag

    = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'

  %body
    %p.notice= notice
    %p.alert= alert

    =yield
```
>devise user를 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate devise user
$ sudo rake db:migrate
```
- 2020-12-08
>simple_form을 설치해줍니다.
``` terminal
$ sudo rails generate simple_form:install
```
>app/models/post.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :user
```
>app/models/user.rb 파일에 다음을 추가합니다.
``` rb
has_many :posts
```
>user와 post를 연결하고 마이그레이션해줍니다.
``` terminal
$ sudo rails generate migration add_user_id_to_posts user_id:integer
$ sudo rake db:migrate
```
>app/views/posts/index.html.haml 파일에 다음을 추가해줍니다.
``` haml
by
= post.user.email
```
- 2020-12-09
>app/views/layouts/application.html.haml을 다음과 같이 수정해줍니다.
``` haml
!!!
%html
  %head
    %title PXZHU's Rails Forum
    = csrf_meta_tags
    = csp_meta_tag

    = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'

    %link(rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.3/normalize.min.css")/
    
  %body
    %header.main_header.clearfix
      .wrapper
        #logo
          %p PXZHU's Rails Forum
        #buttons
          = link_to "New Post", new_post_path

    .wrapper
      %p.notice= notice
      %p.alert= alert

    .wrapper
      =yield
```
>app/assets/stylesheets/application.css 파일을 application.scss 파일로 변경하고 다음을 추가합니다.
``` scss
body {
  background: #EDEFF0;
}

.wrapper {
  width: 60%;
  max-width: 1140px;
  margin: 0 auto;
}

.clearfix:before, .clearfix:after {
  content: " ";
  display: table;
}
.clearfix:after {
  clear: both;
}

.main_header {
  width: 100%;
  margin: 0 auto;
  background: white;
  #logo {
    float: left;
    p {
      text-transform: uppercase;
      font-weight: 700;
      letter-spacing: -1px;
      font-size: 1.2rem;
    }
  }
  #buttons {
    float: right;
  }
}

#posts {
  background: white;
  padding: 2em 5%;
  border-radius: .5em;
  .post {
    margin: 1em 0;
    padding: 1em 0;
    border-bottom: 1px solid #D1D1D1;
    .title {
      margin: 0;
      a {
        color: #397CAC;
        text-decoration: none;
        font-weight: 100;
        font-size: 1.25rem;
      }
    }
    .date {
      margin-top: .25rem;
      font-size: 0.9rem;
      color: #B2BAC2;
    }
  }
}
```
>app/views/posts/index.html.haml 파일에 다음과 같이 수정해줍니다.
``` haml
#posts
  - @posts.each do |post|
    .post
      %h2.title= link_to post.title, post
      %p.date
        Published at
        = time_ago_in_words(post.created_at)
        by
        = post.user.email
```
- 2020-12-10
>app/views/posts/show.html.haml 파일을 다음과 같이 수정합니다.
``` haml
#post_content
  %h1= ...<!-- 이하 생략 -->
```
>app/assets/stylesheets/application.scss 파일에 다음을 추가해줍니다.
``` scss
#post_content {
  background: white;
  padding: 2em 5%;
  border-radius: .5em;
  h1 {
    font-weight: 100;
    font-size: 2em;
    color: #397CAC;
    margin-top: 0;
  }
  p {
    color: #B2BAC2;
    font-size: 0.9rem;
    font-weight: 100;
    line-height: 1.5;
  }
}
```
>app/views/layouts/application.html.haml 파일의 다음을 수정해줍니다.
``` haml
<!-- before -->
  %p PXZHU's Rails Forum
#buttons
  = link_to "New Post", new_post_path
<!-- after -->
  %p= link_to "PXZHU's Rails Forum", root_path
#buttons
  -if user_signed_in?
    = link_to "New Post", new_post_path
  - else
    = link_to "Sign Up", new_user_registration_path
    = link_to "Sign In", new_user_session_path
```
>app/assets/stylesheets/application.scss 파일에 다음을 추가해줍니다.
``` scss
#logo {
  /* 중략 */
  p {
    /* 중략 */
    a {
        text-decoration: none;
        color: #397CAC;
    }
  }
}
```
>app/controllers/posts_controller.rb 파일에 다음을 추가해줍니다. 
``` rb
before_action :authenticate_user!, except: [:index, :show]
```
- 2020-12-11
>Comment 모델을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model Comment comment:text post:references user:references
$ sudo rake db:migrate
```
>app/models/post.rb 파일에 다음을 추가합니다.
``` rb
has_many :comments
```
>app/models/post.rb 파일에 다음을 추가합니다.
``` rb
has_many :comments
```
>confing/routes.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
resources :posts
# after
resources :posts do
  resources :comments
end
```
>Comments 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate controller Comments
```
>app/controllers/comments_controller.rb 파일에 다음을 추가합니다.
``` rb
def create
  @post = Post.find(params[:post_id])
  @comment = @post.comments.create(params[:comment].permit(:comment))

  if @comment.save
    redirect_to post_path(@post)
  else
    render 'new'
  end
end
```
>app/views/comments/_comment.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
.comment
  %p= comment.comment
```
>app/views/comments/_form.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
= simple_form_for([@post, @post.comments.build]) do |f|
  = f.input :comment
  = f.submit
```
>app/views/posts/show.html.haml 파일에 다음을 추가합니다.
``` haml
#comments
  %h2= @post.comments.count
  = render @post.comments

  %h3 Reply to thread
  = render "comments/form"
```
>Comments의 Template 문제로 프로젝트를 일시 중단합니다.
---

## Notenote
- 2020-12-12
>notenote 프로젝트를 생성해줍니다.
``` terminal
$ sudo rails new notenote
```
>controller를 생성해줍니다.
``` terminal
$ sudo rails generate controller Welcome index
```
>config/routes.rb 파일에 다음을 추가합니다.
``` rb
root 'welcome#index'
```
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'haml', '~> 5.2', '>= 5.2.1'
gem 'simple_form', '~> 5.0', '>= 5.0.3'
gem 'devise', '~> 4.7', '>= 4.7.3'
```
``` terminal
$ sudo bundle install
```
>app/views/welcome/index.html.erb 파일을 index.html.haml 파일로 변경하고 다음과 같이 수정해준다.
``` haml
%h1 This is the welcome placeholder
```
- 2020-12-13
>simple_form을 생성하고 Note 모델을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate simple_form:install
$ sudo rails generate model Note title:string content:text
$ sudo rake db:migrate
```
>Notes 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate controller Notes
```
>app/controllers/notes_controller.rb 파일에 다음을 추가합니다.
``` rb
def index
end

def show
end

def new
end

def create
end

def edit
end

def update
end

def destory
end

private

def find_note
end

def note_params
end
```
>config/routes.rb 파일에 다음을 추가합니다.
``` rb
resources :notes
```
- 2020-12-15
>app/views/notes/_form.html.haml 파일을 생성해주고 다음을 추가합니다.    
>app/views/notes/new.html.haml 파일을 생성해주고 다음을 추가합니다.
``` haml
= simple_form_for @note do |f|
  = f.input :title
  = f.input :content
  = f.button :submit
```
``` haml
%h1 Add a New Note

= render 'form'

= link_to "Back", root_path
```
>app/controllers/notes_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
before_action :find_note, only: [:show, :edit, :update, :destory]

def index
  @notes = Note.all.order("created_at DESC")
end
# 중략
def new
  @note = Note.new
end

def create
  @note = Note.new(note_params)

  if @note.save
    redirect_to @note
  else
    render 'new'
  end
end
# 중략
def find_note
  @note = Note.find(params[:id])
end

def note_params
  params.require(:note).permit(:title, :content)
end
```
>app/views/notes/show.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1= @note.title
%p= @note.content

= link_to "All Notes", notes_path
```
>app/views/notes/index.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
- @notes.each do |note|
  %h2= link_to note.title, note
  %p= time_ago_in_words(note.created_at)
```
- 2020-12-16
>app/controllers/notes_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before_action :find_note, only: [:show, :edit, :update, :destroy]
# destory >> destroy 로 오타를 수정합니다.
# before
def update
end

def destory
end
# after
def update
  if @note.update(note_params)
    redirect_to @note
  else
    render 'edit'
  end
end

def destroy
  @note.destroy
  redirect_to notes_path
end
```
>app/views/notes/show.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to "Edit", edit_note_path(@note)
= link_to "Delete", note_path(@note), method: :delete, data: { confirm: "Are you sure?" }
```
>app/views/notes/edit.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 Edit Your Note

= render 'form'

= link_to "Cancle", note_path
```
>app/views/notes/index.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to "New Note", new_note_path
```
- 2020-12-17
>devise를 설치해줍니다.
``` terminal
$ sudo rails generate devise:install
```
>config/environments/development.rb 파일에 다음을 추가합니다.
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>app/views/layouts/application.html.erb 파일에 다음을 추가합니다.
``` erb
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```
>devise view를 생성해줍니다.
``` terminal
$ sudo rails generate devise:views
```
>devise User를 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>note에 user_id를 추가하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate migration add_user_id_to_notes user_id:integer
$ sudo rake db:migrate
```
>app/models/user.rb 파일에 다음을 추가합니다.
``` rb
has_many :notes
```
>app/models/note.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :user
```
>app/controllers/notes_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
def new
  @note = current_user.notes.build
end

def create
  @note = current_user.notes.build(note_params)
```
- 2020-12-21
>app/controllers/notes_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
@notes = Note.all.order("created_at DESC")
# after
@notes = Note.where(user_id: current_user).order("created_at DESC")
```
>config/routes.rb 파일을 다음과 같이 수정해줍니다.
``` rb
resources :notes
  
authenticated :user do
  root 'notes#index', as: "autehnticated_root"
end

root 'welcome#index'
```
>app/assets/stylesheets/normalize.scss를 생성하고 [다음](https://necolas.github.io/normalize.css/8.0.1/normalize.css)을 추가해줍니다.    
>app/assets/stylesheets/global.scss 파일을 생성하고 [다음](https://github.com/mackenziechild/notenote/blob/master/app/assets/stylesheets/global.css.scss)을 추가해줍니다.    
>app/assets/stylesheets/notes.scss 파일에 [다음](https://github.com/mackenziechild/notenote/blob/master/app/assets/stylesheets/notes.css.scss)을 추가해줍니다.    
>app/assets/stylesheets/welcome.scss 파일에 [다음](https://github.com/mackenziechild/notenote/blob/master/app/assets/stylesheets/welcome.css.scss)을 추가해줍니다.    
>app/assets/stylesheets/application.css 파일을 application.scss 파일로 변경한 뒤 다음과 같이 추가해줍니다.
``` scss
/*
 *= require_self
 */

@import 'normalize.scss';
@import 'global.scss';
@import 'notes.scss';
@import 'welcome.scss';
```
>app/assets/images/에 [다음](https://github.com/mackenziechild/notenote/tree/master/app/assets/images)을 추가합니다.
- 2020-12-22
>app/views/layouts/application.html.erb 파일을 application.html.haml 파일로 변경하고 다음과 같이 수정해줍니다.
``` haml
!!!
%html
  %head
    %title NoteNote | Your online Notebook
    = csrf_meta_tags
    = csp_meta_tag

    = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'
  %body
    %p.notice= notice
    %p.alert= alert

    = yield
```
>app/views/welcome/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
#banner
  .banner_content
    %h1 NoteNote
    %p Your online notebook. Never forget an idea again.
    %button= link_to "Sign Up", new_user_registration_path

#testimonial
  .wrapper
    %p.quote "The greatest notebook application. Period"
    %p.name - PXZHU

#callouts
  .callout_inner
    .wrapper
      .callout
        %h2 Notes
        %p I'm baby fam photo booth enamel pin biodiesel. Slow-carb poutine coloring book actually yuccie poke street art enamel pin drinking vinegar raclette.
      .callout
        %h2 Rocket
        %p I'm baby fam photo booth enamel pin biodiesel. Slow-carb poutine coloring book actually yuccie poke street art enamel pin drinking vinegar raclette.
      .callout
        %h2 Lightning
        %p I'm baby fam photo booth enamel pin biodiesel. Slow-carb poutine coloring book actually yuccie poke street art enamel pin drinking vinegar raclette.

#bottom_cta
  .wrapper
    %h2 For Realz!
    %p I want you to sign up... If you don;t, I will find you!
    %button= link_to "Click Meee!!!", new_user_registration_path

%footer
  %p &copy; PXZHU
```
>app/views/notes/index.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
.wrapper_with_padding
  #notes.clearfix
    - unless @notes.blank?
      - @notes.each do |note|
        %a{ href: (url_for [note]) }
          .note
            %p.title= note.title
            %p.date= time_ago_in_words(note.created_at)
    - else
      %h2 Add a note
      %p It appears you haven't created any notes yet... Lets fix that. Why don't you create a new note below.
      %button= link_to "New Note", new_note_path
```
>app/views/notes/show.html.haml 파일을 다음과 같이 수정합니다.
``` haml
.wrapper_with_padding
  #note_show
    %h1.title= @note.title
    %p= simple_format(@note.content)

    .buttons
      = link_to "Edit", edit_note_path(@note), class: "button"
      = link_to "Delete", note_path(@note), method: :delete, data: { confirm: "Are you sure?" }, class: "button"
```
>app/views/notes/new.html.haml과 app/views/notes.edit.html.haml 파일을 다음으로 감싸줍니다.
``` haml
.wrapper_with_padding
  <!-- 이하 생략 -->
```
>app/views/notes/_form.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
= f.button :submit, class: "button"
```
>app/views/devise/registrations/new.html.erb 파일을 다음으로 감싸줍니다.
``` erb
<div class="wrapper_with_padding">
  <!-- 중략 -->
    <%= f.button :submit, "Sign up", class: "button" %>
  <!-- 중략 -->
</div>
```
>app/views/devise/sessions/new.html.erb 파일을 다음으로 감싸줍니다.
``` erb
<div class="wrapper_with_padding">
  <!-- 중략 -->
    <%= f.button :submit, "Log in", class: "button" %>
  <!-- 중략 -->
</div>
```
>app/views/layotus/application.html.haml 파일에 다음을 추가합니다.
``` haml
%link(rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css")/
```
>app/views/welcome/index.html.haml 파일에 다음을 추가해줍니다.
``` haml
.callout
  %i.fa.fa-pencil
  %h2 Notes
  %p I'm baby fam photo booth enamel pin biodiesel. Slow-carb poutine coloring book actually yuccie poke street art enamel pin drinking vinegar raclette.
.callout
  %i.fa.fa-rocket
  %h2 Rocket
  %p I'm baby fam photo booth enamel pin biodiesel. Slow-carb poutine coloring book actually yuccie poke street art enamel pin drinking vinegar raclette.
.callout
  %i.fa.fa-bolt
  %h2 Lightning
  %p I'm baby fam photo booth enamel pin biodiesel. Slow-carb poutine coloring book actually yuccie poke street art enamel pin drinking vinegar raclette.
```
---

## Muse
- 2020-12-22
>post 모델을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model post title:string link:string description:text
$ sudo rake db:migrate
```
>posts 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate controller Posts
```
>config/routes.rb 파일에 다음을 추가합니다.
``` rb
resources :posts

root 'posts#index'
```
>app/controllers/posts_controller.rb 파일에 다음을 추가합니다.
``` rb
def index
end
```
- 2020-12-23
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'haml', '~> 5.2', '>= 5.2.1'
gem 'simple_form', '~> 5.0', '>= 5.0.3'
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'paperclip', '~> 6.1'
```
``` terminal
$ sudo bundle install
```
>app/views/posts/index.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 This is the placeholder ;)
```
- 2020-12-24
>app/controllers/posts_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
before_action :find_post, only: [:show, :edit, :update, :destroy]
def index
  @posts = Post.all.order("created_at DESC")
end

def show
  @post = Post.find(params[:id])
end

def new
  @post = Post.new
end

def create
  @post = Post.new(post_params)

  if @post.save
    redirect_to @post
  else
    render 'new'
  end
end

def edit
end

def update
  if @post.update(post_params)
    redirect_to @post
  else
    render 'edit'
  end
end

def destroy
  @post.destroy
  redirect_to root_path
end

private

def find_post
  @post = Post.find(params[:id])
end

def post_params
  params.require(:post).permit(:title, :link, :description)
end
```
>app/views/posts/new.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1 Add New Inspirtaion

= render 'form'

= link_to 'Back', root_path
```
>app/views/posts/_form.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
= simple_form_for @post do |f|
  = f.input :title
  = f.input :link
  = f.input :description
  
  = f.button :submit
```
>app/views/posts/show.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
%h1= @post.title
%p= @post.link
%p= @post.description

= link_to "Home", root_path
= link_to "Edit", edit_post_path(@post)
= link_to "Destory", post_path(@post), method: :delete, data: { confirm: "Are you sure?" }
```
>app/views/posts/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
- @posts.each do |post|
  %h2= link_to post.title, post

= link_to "Add New Inspiration", new_post_path
```
- 2020-12-25
>devise를 설치해줍니다.
``` terminal
$ sudo rails generate devise:install
```
>config/environments/development.rb 파일에 다음을 추가해줍니다.
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>app/views/layouts/application.html.erb 파일에 다음을 추가합니다.
``` erb
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```
>devise User 모델을 생성하고 마이그레이션 해줍니다.    
>user와 post를 연결하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate devise User
$ sudo rake db:migrate
$ sudo rails generate migration add_user_id_to_post user_id:integer
$ sudo rake db:migrate
```
>app/models/user.rb 파일에 다음을 추가합니다.
``` rb
has_many :posts
```
>app/models/post.rb 파일에 다음을 추가합니다.
``` rb
belongs_to :user
```
>app/controllers/posts_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# ...
before_action :authenticate_user!, except: [:index, :show]
# 중략
def new
  @post = current_user.posts.build
end

def create
  @post = current_user.posts.build(post_params)
```
>User 모델에 이름을 추가하고 마이그레이션 해줍니다.    
>Devise 뷰를 생성해줍니다.
``` terminal
$ sudo rails generate migration add_name_to_user name:string
$ sudo rake db:migrate
$ sudo rails generate devise:views
```
>app/views/devise/registrations/new.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
%= f.input :name,
            required: true,
            autofocus: true,
            input_html: { autocomplete: "name" }%>
<%= f.input :email,
            required: true,
            input_html: { autocomplete: "email" }%>
```
>app/views/devise/registrations/edit.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<%= f.input :name, required: true, autofocus: true %>
<%= f.input :email, required: true %>
```
>app/controllers/application_controller.rb 파일에 다음을 추가해줍니다.
``` rb
# 문법 변경으로 인해 수정하였음.
before_action :configure_permitted_parameters, if: :devise_controller?

protected

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  devise_parameter_sanitizer.permit(:account_update, keys: [:name])
end
```
>app/views/posts/show.html.haml 파일에 다음을 추가합니다.
``` haml
%p= @post.user.name
```
>app/models/post.rb 파일에 다음을 추가합니다.
``` rb
has_attached_file :image, styles: { medium: "700x500#", small: "350x250#" }
validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
```
>paperclip을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate paperclip post image
$ sudo rake db:migrate
# 오류 발생 시  migrate 파일 버전을 수정해준다. ex) [6.0]
```
>app/views/posts/_form.html.haml 파일에 다음을 추가합니다.
``` haml
= f.input :image
```
>app/controllers/posts_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
params.require(:post).permit(:title, :link, :description)
# after
params.require(:post).permit(:title, :link, :description, :image)
```
>app/views/posts/show.html.haml 파일에 다음을 추가합니다.
``` haml
= image_tag @post.image.url(:medium)
```
>app/views/posts/index.html.haml 파일에 다음을 추가합니다.
``` haml
= link_to (image_tag post.image.url(:small)), post
<!-- 중략 -->
%p
  = post.comments.count
  Comments
```
>comment 모델을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model comment content:text post:references user:references
$ sudo rake db:migrate
```
>app/models/user.rb와 post.rb 파일에 각각 다음을 추가해줍니다.
``` rb
has_many :comments
```
>config/routes.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
resources :posts
# after
resources :posts do
  resources :comments
end
```
>comments 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate controller comments
```
>app/controllers/comments_controller.rb 파일에 다음을 추가합니다.
``` rb
before_action :authenticate_user!
def create
  @post = Post.find(params[:post_id])
  @comment = Comment.create(params[:comment].permit(:content))
  @comment.user_id = current_user.id
  @comment.post_id = @post.id

  if @comment.save
    redirect_to  post_path(@post)
  else
    render 'new'
  end
end
```
>app/views/comments/_form.html.haml 파일을 생성하고 다음을 추가합니다.
``` haml
= simple_form_for([@post, @post.comments.build]) do |f|
  = f.input :content, label: "Reply to thread"
  = f.button, :submit, class: "button"
```
>app/views/posts/show.html.haml 파일에 다음을 추가합니다.
``` haml
#comment
  %h2.comment_count= pluralize(@post.comments.count, "Comment")
  - @comments.each do |comment|
    .comment
      %p.username= comment.user.name
      %p.content= comment.content

  = render 'comments/form'
```
>app/controllers/posts_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
def show
  @comments = Comment.where(post_id: @post)
end
```
- 2020-12-26
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'acts_as_votable', '~> 0.13.1'
```
``` terminal
$ sudo bundle install
```
>acts_as_votable을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate acts_as_votable:migration
$ sudo rake db:migrate
```
>app/models/post.rb 파일에 다음을 추가합니다.
``` rb
acts_as_votable
```
>config/routes.rb 파일에 다음을 추가합니다.
``` rb
member do
  get "like", to: "posts#upvote"
  get "dislike", to: "posts#downvote"
end
```
>app/controllers/posts_controller.rb 파일에 다음을 추가해줍니다.
``` rb
before_action :find_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
# 중략
def upvote
  @post.upvote_by current_user
  redirect_back fallback_location: root_path
end

def downvote
  @post.downvote_by current_user
  redirect_back fallback_location: root_path
end
```
>app/views/posts/show.html.haml 파일에 다음을 추가해줍니다.
``` haml
%p
  = @post.get_upvotes.size
  Likes
%p
  = @post.get_downvotes.size
  DisLikes
= link_to "Like", like_post_path(@post), method: :get
= link_to "Dislike", dislike_post_path(@post), method: :get
```
>app/views/posts/index.html.haml 파일에 다음을 추가합니다.
``` haml
%p
  = post.get_likes.size
  Likes
```
>app/views/layouts/application.html.erb 파일을 application.html.haml 파일로 변경하고 다음과 같이 수정해줍니다.
``` haml
!!!
%html
  %head
    %title Muse
    = csrf_meta_tags
    = csp_meta_tag

    %link(rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css")/
    %link(rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css")/
    = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'
  %body
    %header
      .wrapper.clearfix
        #logo= link_to "Muse", root_path
        %nav
          - if user_signed_in?
            = link_to current_user.name, edit_user_registration_path
            = link_to "Add New Inspiration", new_post_path, class: "button"
          - else
            = link_to "Sign In", new_user_session_path
            = link_to "Sign Up", new_user_registration_path, class: "button"
    %p.notice= notice
    %p.alert= alert

    = yield
```
>app/assets/stylesheets/application.css 파일을 application.scss 파일로 변경하고 [다음](https://github.com/mackenziechild/muse/blob/master/app/assets/stylesheets/application.css.scss)을 추가하고 다음 사항을 수정해줍니다.    
``` scss
/* before */
@import 'home.css.scss';
@import 'post.css.scss';
/* after */
@import 'home.scss';
@import 'post.scss';
```
>app/assets/stylesheets/comments.scss와 posts.scss를 삭제합니다.    
>app/assets/stylesheets/post.scss를 생성하고 [다음](https://github.com/mackenziechild/muse/blob/master/app/assets/stylesheets/home.css.scss)을 추가해줍니다.    
>app/assets/stylesheets/home.scss를 생성하고 [다음](https://github.com/mackenziechild/muse/blob/master/app/assets/stylesheets/post.css.scss)을 추가해줍니다.    
>app/views.layouts/application.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
.wrapper
  = yield
```
>app/views/posts/index.html.haml 파일에 다음을 추가합니다.
``` haml
- if user_signed_in?
  %p#intro
    Hello
    = current_user.name
    %br/
    %span
      Share your inspration and see what's inspiring others.
- else
  %p#intro
    What's your muse?
    %br/
    %span
      Share your inspration and see what's inspiring others.

#posts
  - @posts.each do |post|
    .post
      .post_image
        = link_to (image_tag post.image.url(:small)), post
      .post_content
        .title
          %h2= link_to post.title, post
        .data.clearfix
          %p.username
            Shared by
            = post.user.name
          %p.buttons
            %span
              %i.fa.fa-comments-o
              = post.comments.count
            %span
              %i.fa.fa-thumbs-o-up
              = post.get_likes.size
```
>app/views/posts/show.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
#post_show
  %h1= @post.title
  %p.username
    Share by
    = @post.user.name
    about
    = time_ago_in_words(@post.created_at)
  .clearfix
    .post_image_description
      = image_tag @post.image.url(:medium)
      .description= simple_format(@post.description)
    .post_data
      = link_to "Visit Link", @post.link, class: "button"
      = link_to like_post_path(@post), method: :get, class: "data" do
        %i.fa.fa-thumbs-o-up
        = pluralize(@post.get_upvotes.size, "Like")
      = link_to dislike_post_path(@post), method: :get, class: "data" do
        %i.fa.fa-thumbs-o-down
        = pluralize(@post.get_downvotes.size, "Dislike")
      %p.data
        %i.fa.fa-comments-o
        = pluralize(@post.comments.count, "Comment")
      - if @post.user == current_user
        = link_to "Edit", edit_post_path(@post), class: "data"
        = link_to "Delete", post_path(@post), method: :delete, data: { confirm: "Are you sure?" }, class: "data"

#comments
  %h2.comment_count= pluralize(@post.comments.count, "Comment")
  - @comments.each do |comment|
    .comment
      %p.username= comment.user.name
      %p.content= comment.content

  = render 'comments/form'
```
>app/views/layouts/application.html.haml 파일의 다음을 수정합니다.
``` haml
= stylesheet_link_tag 'application', media: 'all'
= javascript_pack_tag 'application'
```
>app/javascript/packs/application.js 파일의 다음을 삭제합니다.
``` js
require("turbolinks").start()
```
>Gemfile의 다음을 삭제하고 번들을 새로고침 해줍니다.
``` gemfile
gem 'turbolinks', '~> 5'
```
``` terminal
$ sudo bundle
```
>app/views/posts/show.html.haml 파일에 다음을 추가합니다.
``` haml
#random_post
  %h3 Random Inspiration
  .post
    .post_image
      = link_to (image_tag @random_post.image.url(:small)), post_path(@random_post)
    .post_content
      .title
        %h2= link_to @random_post.title, post_path(@random_post)
      .data.clearfix
        %p.username
          Shared by
          = @random_post.user.name
        %p.buttons
          %span
            %i.fa.fa-comments-o
            = @random_post.comments.count
          %span
            %i.fa.fa-thumbs-o-up
            = @random_post.get_likes.size
```
>app/controllers/posts_controller.rb 파일에 다음을 추가합니다.
``` rb
@random_post = Post.where.not(id: @post).order("RANDOM()").first
```