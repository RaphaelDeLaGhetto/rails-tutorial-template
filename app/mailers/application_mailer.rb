class ApplicationMailer < ActionMailer::Base
  default from: ENV['default_from']
  layout 'mailer'
end
