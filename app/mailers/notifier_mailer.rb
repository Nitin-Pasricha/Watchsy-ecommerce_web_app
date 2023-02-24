class NotifierMailer < ApplicationMailer
    default from: 'notifications@watchsy.com'

    def purchase_complete
        @user = params[:user]
        @amount = params[:amount]
        @url = 'http://localhost:3000/gallery/index'
        mail(to: @user.email, subject:'Your Watchsy Order Confirmation')
    end
end
