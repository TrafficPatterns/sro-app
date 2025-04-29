import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:sro/global_widgets/custom_button.dart';
import 'package:sro/services/global_functions.dart';
import 'package:sro/themes/app_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  final bool? hasButton;
  final VoidCallback? onTapDismiss;

  const PrivacyPolicy({Key? key, this.hasButton = false, this.onTapDismiss})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Center(
        child: Container(
          height: getSizeWrtHeight(450),
          width: getSize(350),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HtmlWidget(''' <div class="d-flex justify-content-center">
               <div class="content" role="main">
                        
                        <h2>SRO App Privacy Policy:</h2>
                        <h2>Last updated July 14, 2022</h2> 
              
                        <p>  
                        SRO App ("SRO",“we” or “us” or “our”) respects the privacy of our users (“user” or “you”). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our mobile application (the “SRO”).
                        <br>
                        
                        <b>please read this Privacy Policy carefully. IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT ACCESS THE APPLICATION.
                        </b>
                        </p>
              
                        <p>
                        We reserve the right to make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of this Privacy Policy. You are encouraged to periodically review this Privacy Policy to stay informed of updates. You will be deemed to have been made aware of, will be subject to, and will be deemed to have accepted the changes in any revised Privacy Policy by your continued use of the Application after the date such revised Privacy Policy is posted.
                        This Privacy Policy does not apply to the third-party online/mobile store from which you install the Application or make payments, including any in-game virtual items, which may also collect and use data about you. We are not responsible for any of the data collected by any such third party.
                      
                        This Privacy Policy was created using Termly's Privacy Policy Generator.
                        
                        <h2>COLLECTION OF YOUR INFORMATION</h2>
                        
                        We may collect information about you in a variety of ways. The information we may collect via the Application depends on the content and materials you use, and includes:
                        
                        <h2>Personal Data</h2>
                        <p>
                        Demographic and other personally identifiable information (such as your name and email address) that you voluntarily give to us when choosing to participate in various activities related to the Application, such as chat, posting messages in comment sections or in our forums, liking posts, sending feedback, and responding to surveys. If you choose to share data about yourself via your profile, online chat, or other interactive areas of the Application, please be advised that all data you disclose in these areas is public and your data will be accessible to anyone who accesses the Application.
                        
                        <h2>Derivative Data</h2>
                        
                        Information our servers automatically collect when you access the Application, such as your native actions that are integral to the Application, including liking, re-blogging, or replying to a post, as well as other interactions with the Application and other users via server log files.
                        
                        <h2>Geo-Location Information</h2>
                        
                        We may request access or permission to and track location-based information from your mobile device, either continuously or while you are using the Application, to provide location-based services. If you wish to change our access or permissions, you may do so in your device’s settings.
                        
                        <h2>Mobile Device Data</h2>
                        
                        Device information such as your mobile device ID number, model, and manufacturer, version of your operating system, phone number, country, location, and any other data you choose to provide.
                        
                        <h2>Push Notifications</h2>
                        
                        We may request to send you push notifications regarding your account or the Application. If you wish to opt-out from receiving these types of communications, you may turn them off in your device’s settings.
                        
                        <h2>Third-Party Data</h2>
                        
                        Information from third parties, such as personal information or network friends, if you connect your account to the third party and grant the Application permission to access this information.
                        
                        <h2>Data From Contests, Giveaways, and Surveys</h2>
                        
                        Personal and other information you may provide when entering contests or giveaways and/or responding to surveys.
                        
                        <h2>USE OF YOUR INFORMATION</h2>
                        
                        Having accurate information about you permits us to provide you with a smooth, efficient, and customized experience. Specifically, we may use information collected about you via the Application to:
                        
                        1.Administer sweepstakes, promotions, and contests. <br>
                        2.Assist law enforcement and respond to subpoena.<br>
                        3.Compile anonymous statistical data and analysis for use internally or with third parties.<br>
                        4.Create and manage your account.<br>
                        5.Deliver targeted advertising, coupons, newsletters, and other information regarding promotions and the Application to you.<br>
                        6.Email you regarding your account or order.<br>
                        7.Enable user-to-user communications.<br>
                        8.Fulfill and manage purchases, orders, payments, and other transactions related to the Application.<br>
                        9.Generate a personal profile about you to make future visits to the Application more personalized.<br>
                        10.Increase the efficiency and operation of the Application.<br>
                        11.Monitor and analyze usage and trends to improve your experience with the Application.<br>
                        12.Notify you of updates to the Application.<br>
                        13.Offer new products, services, mobile applications, and/or recommendations to you.<br>
                        14.Perform other business activities as needed.<br>
                        15.Prevent fraudulent transactions, monitor against theft, and protect against criminal activity.<br>
                        16.Process payments and refunds.<br>
                        17.Request feedback and contact you about your use of the Application.<br>
                        18.Resolve disputes and troubleshoot problems.<br>
                        19.Respond to product and customer service requests.<br>
                        20.Send you a newsletter.<br>
                        21.Solicit support for the Application.<br>
              
                        <h2>DISCLOSURE OF YOUR INFORMATION</h2>
                        
                        We may share information we have collected about you in certain situations. Your information may be disclosed as follows:
                        
                        <h2>By Law or to Protect Rights</h2>
                        
                        If we believe the release of information about you is necessary to respond to legal process, to investigate or remedy potential violations of our policies, or to protect the rights, property, and safety of others, we may share your information as permitted or required by any applicable law, rule, or regulation. This includes exchanging information with other entities for fraud protection and credit risk reduction.
                        
                        <h2>Third-Party Service Providers</h2>
                        
                        We may share your information with third parties that perform services for us or on our behalf, including payment processing, data analysis, email delivery, hosting services, customer service, and marketing assistance.
                        
                        <h2>Marketing Communications</h2>
                        
                        With your consent, or with an opportunity for you to withdraw consent, we may share your information with third parties for marketing purposes, as permitted by law.
                        
                        <h2>Interactions with Other Users</h2>
                        
                        If you interact with other users of the Application, those users may see your name, profile photo, and descriptions of your activity, including sending invitations to other users, chatting with other users, liking posts, following blogs.
                        
                        <h2>Online Postings</h2>
                        
                        When you post comments, contributions or other content to the Applications, your posts may be viewed by all users and may be publicly distributed outside the Application in perpetuity
                        
                        <h2>Third-Party Advertisers</h2>
                        
                        We may use third-party advertising companies to serve ads when you visit the Application. These companies may use information about your visits to the Application and other websites that are contained in web cookies in order to provide advertisements about goods and services of interest to you.
                        
                        <h2>Affiliates</h2>
                        
                        We may share your information with our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include our parent company and any subsidiaries, joint venture partners or other companies that we control or that are under common control with us.
                        
                        <h2>Business Partners</h2>
                        
                        We may share your information with our business partners to offer you certain products, services or promotions.
                        
                        <h2>Offer Wall</h2>
                        
                        The Application may display a third-party-hosted “offer wall.” Such an offer wall allows third-party advertisers to offer virtual currency, gifts, or other items to users in return for acceptance and completion of an advertisement offer. Such an offer wall may appear in the Application and be displayed to you based on certain data, such as your geographic area or demographic information. When you click on an offer wall, you will leave the Application. A unique identifier, such as your user ID, will be shared with the offer wall provider in order to prevent fraud and properly credit your account.
                        
                        <h2>Social Media Contacts</h2>
                       
                        
                        If you connect to the Application through a social network, your contacts on the social network will see your name, profile photo, and descriptions of your activity.
                        
                        <h2>Other Third Parties</h2>
                        
                        We may share your information with advertisers and investors for the purpose of conducting general business analysis. We may also share your information with such third parties for marketing purposes, as permitted by law.
                        
                        <h2>Sale or Bankruptcy</h2>
                        
                        If we reorganize or sell all or a portion of our assets, undergo a merger, or are acquired by another entity, we may transfer your information to the successor entity. If we go out of business or enter bankruptcy, your information would be an asset transferred or acquired by a third party. You acknowledge that such transfers may occur and that the transferee may decline honor commitments we made in this Privacy Policy.
                        
                        We are not responsible for the actions of third parties with whom you share personal or sensitive data, and we have no authority to manage or control third-party solicitations. If you no longer wish to receive correspondence, emails or other communications from third parties, you are responsible for contacting the third party directly.
                        
                        <h2>TRACKING TECHNOLOGIES</h2>
                        
                        <h2>Cookies and Web Beacons</h2>
                        
                        We may use cookies, web beacons, tracking pixels, and other tracking technologies on the Application to help customize the Application and improve your experience. When you access the Application, your personal information is not collected through the use of tracking technology. Most browsers are set to accept cookies by default. You can remove or reject cookies, but be aware that such action could affect the availability and functionality of the Application. You may not decline web beacons. However, they can be rendered ineffective by declining all cookies or by modifying your web browser’s settings to notify you each time a cookie is tendered, permitting you to accept or decline cookies on an individual basis.
                        
                        <h2>Internet-Based Advertising</h2>
                        
                        Additionally, we may use third-party software to serve ads on the Application, implement email marketing campaigns, and manage other interactive marketing initiatives. This third-party software may use cookies or similar tracking technology to help manage and optimize your online experience with us. For more information about opting-out of interest-based ads, visit the Network Advertising Initiative Opt-Out Tool or Digital Advertising Alliance Opt-Out Tool.
                        
                        <h2>Website Analytics</h2>
                        
                        We may also partner with selected third-party vendors, such as  Google Analytics to allow tracking technologies and remarketing services on the Application through the use of first party cookies and third-party cookies, to, among other things, analyze and track users’ use of the Application, determine the popularity of certain content, and better understand online activity. By accessing the Application, you consent to the collection and use of your information by these third-party vendors. You are encouraged to review their privacy policy and contact them directly for responses to your questions. We do not transfer personal information to these third-party vendors.
                        
                        You should be aware that getting a new computer, installing a new browser, upgrading an existing browser, or erasing or otherwise altering your browser’s cookies files may also clear certain opt-out cookies, plug-ins, or settings.
                        
                        <h2>THIRD-PARTY WEBSITES</h2> 
                        
                        The Application may contain links to third-party websites and applications of interest, including advertisements and external services, that are not affiliated with us. Once you have used these links to leave the Application, any information you provide to these third parties is not covered by this Privacy Policy, and we cannot guarantee the safety and privacy of your information. Before visiting and providing any information to any third-party websites, you should inform yourself of the privacy policies and practices (if any) of the third party responsible for that website, and should take those steps necessary to, in your discretion, protect the privacy of your information. We are not responsible for the content or privacy and security practices and policies of any third parties, including other sites, services or applications that may be linked to or from the Application.
                        
                        <h2>SECURITY OF YOUR INFORMATION</h2> 
                        
                        We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable, and no method of data transmission can be guaranteed against any interception or other type of misuse. Any information disclosed online is vulnerable to interception and misuse by unauthorized parties. Therefore, we cannot guarantee complete security if you provide personal information.
                        
                        <h2>POLICY FOR CHILDREN</h2>
                        
                        We do not knowingly solicit information from or market to children under the age of 13. If you become aware of any data we have collected from children under age 13, please contact us using the contact information provided below.
                        
                        <h2>CONTROLS FOR DO-NOT-TRACK FEATURES</h2> 
                        
                        Most web browsers and some mobile operating systems and our mobile applications include a Do-Not-Track (“DNT”) feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. No uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this Privacy Policy.
                        
                        <h2>OPTIONS REGARDING YOUR INFORMATION</h2> 
                        
                        <h2>Account Information</h2> 
                        
                        You may at any time review or change the information in your account or terminate your account by:
                        
                        Logging into your account settings and updating your account
                        Contacting us using the contact information provided below
              
                        Upon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, some information may be retained in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our Terms of Use and/or comply with legal requirements.
                        
                        <h2>Emails and Communications</h2>
                        
                        If you no longer wish to receive correspondence, emails, or other communications from us, you may opt-out by:
                        
                        Noting your preferences at the time you register your account with the Application
                        Logging into your account settings and updating your preferences.
                        Contacting us using the contact information provided below
                        If you no longer wish to receive correspondence, emails, or other communications from third parties, you are responsible for contacting the third party directly.
                        
                        <h2>CALIFORNIA PRIVACY RIGHTS</h2>
                        
                        California Civil Code Section 1798.83, also known as the “Shine The Light” law, permits our users who are California residents to request and obtain from us, once a year and free of charge, information about categories of personal information (if any) we disclosed to third parties for direct marketing purposes and the names and addresses of all third parties with which we shared personal information in the immediately preceding calendar year. If you are a California resident and would like to make such a request, please submit your request in writing to us using the contact information provided below.
                        
                        If you are under 18 years of age, reside in California, and have a registered account with the Application, you have the right to request removal of unwanted data that you publicly post on the Application. To request removal of such data, please contact us using the contact information provided below, and include the email address associated with your account and a statement that you reside in California. We will make sure the data is not publicly displayed on the Application, but please be aware that the data may not be completely or comprehensively removed from our systems.
                        
                        <h2>CONTACT US</h2> 
                        
                        If you have questions or comments about this Privacy Policy, please contact us at:
                        
                        SRO
                        
                        info@sro.com
                        <br>
                        <br>
                        <br>
              
              </div>
              </div>'''),
                if (hasButton!)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      onTap: Get.back,
                      text: 'Dismiss',
                      color: const Color(0xff164B9B),
                      textStyle: AppFonts.poppinsMedium16White,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
