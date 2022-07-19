//
//  RegisterViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/10.
//

import UIKit
import WebKit

class RegisterViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var termsWeb: WKWebView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var isScrollEnd: Bool = false
    var isChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsWeb.navigationDelegate = self
        termsWeb.scrollView.delegate = self
        
        isScrollEnd = false
        isChecked = false
        
        setUI()
        
        DispatchQueue.main.async {
            
//            if let url = URL(string: "https://terms.line.me/line_tw_privacy_policy?lang=zh-Hant") {
//                self.termsWeb.load(URLRequest(url: url))
//            }
            self.termsWeb.loadHTMLString(self.urlStr, baseURL: nil)
        }
    }
    
    func setUI() {
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.title = "register".localized
        
        checkBtn.setImage(UIImage(named: "check_disable")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
        checkBtn.addTarget(self, action: #selector(checkBtnClick), for: UIControl.Event.touchDown)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        nextBtn.setTitle("next_btn".localized, for: .normal)
    }
    
    func checkScrollEnd() {
        if let scroll = termsWeb?.scrollView {
            if scroll.bounds.height + scroll.contentOffset.y >= scroll.contentSize.height {
                isScrollEnd = true
                checkLabel.isHidden = true
                checkBtn.setImage(UIImage(named: "check_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
            }
        }
    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        checkScrollEnd()
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.isDecelerating || scrollView.isDragging) && !termsWeb.isLoading && !isScrollEnd {
            checkScrollEnd()
        }
    }
    
    @objc func checkBtnClick() {
        if (isScrollEnd) {
            isChecked = !isChecked
            if (isChecked) {
                checkBtn.setImage(UIImage(named: "check_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
                nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            } else {
                checkBtn.setImage(UIImage(named: "check_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
                nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            }
        }
    }
    
    @objc func nextBtnClick() {
        if (isChecked) {
            let register2ViewController = UIStoryboard(name: "Register2", bundle: nil).instantiateViewController(withIdentifier: "register2ViewController")
            self.navigationController?.pushViewController(register2ViewController, animated: true)
        }
    }
    
    
    let urlStr = """
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
    </head>

    <body style="background-color: #000000; color:#BEBEBE">
        <h1 style="color:#ffffff; text-align:center;">Privacy Policy</h1>
        <p>
            Privacy is of utmost importance at the numiner.io group of companies. We recognise the significance of
            protecting information which is stored on our servers or network or is intended to be stored on our servers or
            network and which relates to an individual. The data we protect are the “Personal Data” which is any information
            relating to an identified or identifiable natural person, sometimes called a data subject, and have made
            protecting the privacy and the confidentiality of Personal Data a fundamental component of the way we do
            business. This Privacy Policy informs you of the ways we work to ensure privacy and the confidentiality of
            Personal Data and describes the information we gather, how we use those Personal Data and the circumstances
            under which we disclose such information to third-parties.<br />
            This Privacy Policy is designed to address regulatory requirements of the jurisdictions in which numiner.io
            offers its Services, including the General Data Protection Regulation (“GDPR”), as enacted by the European
            Commission. In this Privacy Policy, the term “Service” and “Services” has the same meaning as described in the
            User Agreement, but excludes API services, which are governed by a separate agreement. If you do not agree with
            this Privacy Policy, in general, or any part of it, you should not use the Services. This Privacy Policy is
            periodically reviewed to ensure that any new obligations and changes to our business model are taken into
            consideration. We may amend this Privacy Policy at any time by posting an amended version on our website.</p>
        <h3 style="color:#ffffff;">1. INFORMATION ABOUT numiner.io</h3>
        <p>Our Services are offered through fnuminer.io. By using the Services, you understand that your Personal Data
            may
            be processed by one or more of those subsidiaries (each, a “Data Controller”):
            You may contact our Data Protection Officer (“DPO”) by email at support@numiner.io.</p>
        <h3 style="color:#ffffff;">2. COLLECTION OF PERSONAL DATA</h3>
        <p>When you access or use the Services, we collect the following information:
            Information you may provide to us: You may give us information about you by filling in forms on our website or
            through our app or by corresponding with us by phone, email or otherwise. This includes information you provide
            when you register to use the Services and when you report a problem with the website or with our app.
            Information we collect about you: With regard to each of your visits to our website or our app we automatically
            collect the following information:
            Login Information: We log technical information about your use of the Services, including the type of browser
            and version you use, the wallet identifier, the last access time of your wallet, the Internet Protocol (IP)
            address used to create the wallet and the most recent IP address used to access the wallet.
            Device Information: We collect information about the device you use to access your account, including the
            hardware model, operating system and version, and unique deviWe ce identifiers, but this information is
            anonymised and not tied to any particular person.
            Transaction Information: In connection with our Conversion Service, as such term is defined in our User
            Agreement, we may collect and maintain information relating to transactions you effect in your Wallet that
            convert one virtual currency to another (e.g. Bitcoin for Ether).
            Information We Collect Required By Law, Rule, or Regulation: Depending on the Service, we may collect
            information from you in order to meet regulatory obligations around know-your-customer (“KYC”) and anti-money
            laundering (“AML”) requirements. Information that we collect from you includes the following:
            Full name
            Residential address
            Contact details (telephone number, email address)
            Date and place of birth, gender, place of citizenship
            Bank account information and/or credit card details
            Your status as a politically exposed person
            Source of funds & proof of address
            Passport and/or national driver’s license or government-issued identification card to verify your identity
            Transaction history and account balances in connection with your use of certain Services.
            Information We Collect from Other Sources: We also receive information from other sources and combine that with
            the information we collect through our Services. For instance:
            We use third-party services that may be co-branded as numiner.io but will do so with clear notice. Any
            third-party services may collect information as determined by their own privacy policies.
            We also use "cookies" from time to time to help personalise your online experience with us. A cookie is a small
            text file that is stored on your computer to help us make your visit to our site more “user-friendly.” Please
            see our Cookies Policy for more details about the cookies we use. Cookies provide us with information about your
            use of the site that can help us improve the site and your experience with it. We will process Personal Data
            collected through cookies in accordance with this Privacy Policy. If you have set your browser to alert you
            before accepting cookies, you should receive an alert message with each cookie. You may refuse cookies by
            turning them off in your browser, however, you should be aware that our site, like most other popular sites, may
            not work well with cookies disabled.
            Banks or payment processors that you use to transfer fiat currency may provide us with basic Personal Data, such
            as your name and address, as well as, your bank account information.
            Advertising or analytics providers may provide us with anonymised information about you, including but not
            limited to, how you found our website.
        <h3 style="color:#ffffff;">3. USE OF PERSONAL DATA</h3>
        <p>We will use your Personal Data, to:
            Understand and strive to meet your needs and preferences in using our Services;
            Develop new and enhance existing service and product offerings;
            Manage and develop our business and operations;
            Carry out any actions for which we have received your consent;
            Prevent and investigate fraudulent or other criminal activity;
            To address service requests and resolve user questions; and
            Meet legal and regulatory requirements.
            We also reserve the right to use aggregated Personal Data to understand how our users use our Services, provided
            that those data cannot identify any individual.
            We also use third-party web analytics tools that help us understand how users engage with our website. These
            third-parties may use first-party cookies to track user interactions to collect information about how users use
            our website. This information is used to compile reports and to help us improve our website. The reports
            disclose website trends without identifying individual visitors. You can opt-out of such third-party analytic
            tools without affecting how you visit our site. For more information on opting-out, please contact
            support@numiner.io.
            We will process your Personal Data legally and fairly and not use it outside the purposes of which we have
            informed you, including selling it individually or in the aggregate for commercial use.</p>
        <h3 style="color:#ffffff;">4.DISCLOSURE OF PERSONAL DATA</h3>
        <p>We may share your information with selected recipients to perform functions required to provide certain Services
            to you and/or in connection with our efforts to prevent and investigate fraudulent or other criminal activity.
            All such third parties will be contractually bound to protect data in compliance with our Privacy Policy. The
            categories of recipients include:
            Cloud service providers to store certain personal data and for disaster recovery services, as well as, for the
            performance of any contract we enter into with you.
            Fraud detection service providers who will run certain fraud detection checks against Personal Data provided.
            Spam and abuse detection providers making software available designed to prevent users from programatically
            using the Services in unsupported ways.
            We also may share Personal Data with a buyer or other successor in the event of a merger, divestiture,
            restructuring, reorganisation, dissolution or other sale or transfer of some or all of numiner.io’s assets,
            whether as a going concern or as part of bankruptcy, liquidation or similar proceeding, in which Personal Data
            held by numiner.io is among the assets transferred.
            Except where we are required by law to disclose Personal Data, or are exempted from, released from or not
            subject to any legal requirement concerning the disclosure of Personal Data, we will require any person to whom
            we provide your Personal Data to agree to comply with our Privacy Policy in force at that time or requirements
            substantially similar to such policy. We will make reasonable commercial efforts to ensure that they comply with
            such policy or requirements, however, where not expressly prohibited by law, we will have no liability to you,
            if any person fails to do so.
            We shall require any third-party, including without limitation, any government or enforcement entity, seeking
            access to the data we hold to a court order, or equivalent proof that they are statutorily authorised to access
            your data and that their request is valid and within their statutory or regulatory power.
            Funding and transaction information related to your use of certain Services may be recorded on a public block
            chain. Public block chains are distributed ledgers, intended to immutably record transactions across wide
            networks of computer systems. Many block chains are open to forensic analysis which can lead to deanonymisation
            and the unintentional revelation of private financial information, especially when block chain data is combined
            with other data.
            Because block chains are decentralised or third-party networks that are not controlled or operated by numiner.io
            or its affiliates, we are not able to erase, modify, or alter Personal Data from such networks</p>
        <h3 style="color:#ffffff;">5. SECURITY OF YOUR PERSONAL DATA</h3>
        <p>We protect Personal Data with appropriate physical, technological and organisational safeguards and security
            measures. Your Personal Data comes to us via the internet which chooses its own routes and means, whereby
            information is conveyed from location to location. We audit our procedures and security measures regularly to
            ensure they are being properly administered and remain effective and appropriate. Every member of numiner.io is
            committed to our privacy policies and procedures to safeguard Personal Data. Our site has security measures in
            place to protect against the loss, misuse and unauthorised alteration of the information under our control. More
            specifically, our server uses TLS (Transport Layer Security) security protection by encrypting your Personal
            Data to prevent individuals from accessing such Personal Data as it travels over the internet.</p>
        <h3 style="color:#ffffff;">6. RETENTION OF YOUR PERSONAL DATA</h3>
        <p>The length of time we retain Personal Data outside our back-up system varies depending on the purpose for which
            it was collected and used.
            When Personal Data is no longer necessary for the purpose for which it was collected, we will remove any details
            that identifies you or we will securely destroy the records, where permissible. However, we may need to maintain
            records for a significant period of time (after you cease using a particular Service) as mandated by regulation.
            For example, we are subject to certain anti-money laundering laws that require us to retain the following, for a
            period of five (5) years after our business relationship with you has ended.
            A copy of the records we used in order to comply with our client due diligence obligations;
            Supporting evidence and records of transactions with you and your relationship with us.
            Except where prohibited by law, this period may extend beyond the end of the particular relationship with us,
            but only for as long as we are bound to do so for the audit, regulatory or other accounting purposes. When
            Personal Data is no longer needed, we have procedures either to destroy, delete, erase or convert it to an
            anonymous form. If you have opted-out of receiving marketing communications, we will hold your details on our
            suppression list so that we know you do not want to receive these communications.
            After you have terminated the use of our Services, we reserve the right to maintain your Personal Data as part
            of our standard back-up procedures in an aggregated format.</p>
        <h3 style="color:#ffffff;">7.YOUR RIGHTS</h3>
        <p>The rights that are available to you in relation to the Personal Data we hold about you are outlined below.</p>
        <h4 style="color:#ffffff;">Information Access</h4>
        <p>If you ask us, we will confirm whether we are processing your Personal Data and, if so, what information we
            process and, if requested, provide you with a copy of that information within 30 days from the date of your
            request.</p>
        <h4 style="color:#ffffff;">Rectification</h4>
        <p>It is important to us that your Personal Data is up-to-date. We will take all reasonable steps to make sure that
            your Personal Data remains accurate, complete and up-to-date. If the Personal Data we hold about you is
            inaccurate or incomplete, you are entitled to have it rectified. If we have disclosed your Personal Data to
            others, we will let them know about the rectification where possible. If you ask us, if possible and lawful to
            do so, we will also inform you with whom we have shared your Personal Data so that you can contact them
            directly.
            You may inform us at any time that your personal details have changed by emailing us at
            **support@numiner.io**and we will change your Personal Data in accordance with your instructions. To proceed
            with such requests, in some cases we may need supporting documents from you as proof that we are required to
            keep for regulatory or other legal purposes.</p>
        <h4 style="color:#ffffff;">Erasure</h4>
        <p>You can ask us to delete or remove your Personal Data in certain circumstances such as if we no longer need it,
            provided that we have no legal or regulatory obligation to retain that data. Such requests will be subject to
            any agreements that you have entered into with us, and to any retention limits, we are required to comply with
            in accordance with applicable laws and regulations. If we have disclosed your Personal Data to others, we will
            let them know about the erasure request where possible. If you ask us, if possible and lawful to do so, we will
            also inform you with whom we have shared your Personal Data so that you can contact them directly.</p>
        <h4 style="color:#ffffff;">Processing restrictions</h4>
        <p>You can ask us to block or suppress the processing of your Personal Data in certain circumstances, such as, if
            you contest the accuracy of that Personal Data or object to us processing it. It will not stop us from storing
            your Personal Data. We will inform you before we decide not to agree with any requested restriction. If we have
            disclosed your Personal Data to others, we will let them know about the restriction of processing where
            possible. If you ask us, if possible and lawful to do so, we will also inform you with whom we have shared your
            Personal Data so that you can contact them directly.</p>
        <h4 style="color:#ffffff;">Data portability</h4>
        <p>In certain circumstances, you might have the right to obtain Personal Data you have provided us with (in a
            structured, commonly used and machine-readable format) and to re-use it elsewhere or ask us to transfer this to
            a third party of your choice.</p>
        <h4 style="color:#ffffff;">Objection</h4>
        <p>You can ask us to stop processing your Personal Data, and we will do so if we are:</p>
        <ul>
            <li>Relying on our own or someone else’s legitimate interests to process your Personal Data, except if we can
                demonstrate compelling legal grounds for the processing;</li>
            <li>Processing your Personal Data for direct marketing;</li>
            <li>Processing your Personal Data for research, unless we reasonably believe such processing is necessary or
                prudent
                for the performance of a task carried out in the public interest (such as by a regulatory or enforcement
                agency).</li>
        </ul>
        <h4 style="color:#ffffff;">Automated decision-making and profiling</h4>
        <p>If we make a decision about you based solely on an automated process (e.g. through automatic profiling) that
            affects your ability to access our Services or has another significant effect on you, you can request not to be
            subject to such a decision unless we can demonstrate to you that such a decision is necessary for entering into,
            or the performance of, a contract between us. Even if a decision is necessary for entering into or performing a
            contract, you may contest the decision and require human intervention. We may not be able to offer our Services
            if we agree to such a request by terminating our relationship with you. You can exercise any of these rights by
            contacting us at support@numiner.io.</p>
        <h3 style="color:#ffffff;">8. ACCEPTANCE</h3>
        <p>By using the Services, you signify your agreement to this Privacy Policy. numiner.io reserves the right to
            change or amend this Privacy Policy at any time. If we make any material changes to this Privacy Policy, the
            revised Policy will be posted here and we will notify our users at least 30 days prior to the changes taking
            effect so that you are always aware of what information we collect, how we use it and under what circumstances
            we disclose it. Please check this page frequently to see any updates or changes to this Privacy Policy.</p>
        <h3 style="color:#ffffff;">9. QUESTIONS AND COMPLAINTS</h3>
        <p>Any questions about this Privacy Policy, the collection, use and disclosure of Personal Data by numiner.io or
            access to your Personal Data as required by law (to be disclosed should be directed to support@numiner.io.
            In the event that you wish to make a complaint about how we process your Personal Data, please contact us in the
            first instance at In the event that you wish to make a complaint about how we process your personal data, please
            contact us in the first instance at support@numiner.io and we will attempt to handle your request as soon as
            possible. This is without prejudice to your right to launch a claim with the data protection supervisory
            authority in the country in which you live or work where you think we have violated data protection laws.</p>
        <h4 style="color:#ffffff;">California Residents</h4>
        This section supplements the information in our main Privacy Policy and is intended to provide additional
        privacy disclosures as required under the California Consumer Privacy Act (“CCPA”) concerning the collection and
        disclosure of Personal Information (as defined in the CCPA of California residents in the preceding 12 months.
        <h4 style="color:#ffffff;">Categories of Information</h4>
        In the preceding 12 months we have collected the following information:
        <ul>
            <li>Identifiers, such as name, contact information, online identifiers, email address, account name and other
                government-issued identifiers;</li>

            <li>Commercial information, such as transaction information and transaction history;</li>
            <li>Internet or network activity information, such as browsing history and interactions with our website;</li>
            <li>Geolocation data, such as device location and IP location;</li>
            Biometric data;
            <li>Professional or employment related information.</li>
        </ul>
        <p>We may use this personal information for the following business purposes: (i) to operate, manage, and maintain
            our business, (ii) to provide our products and services, and (iii) to accomplish our business purposes and
            objectives, including, for example, using personal information to develop, improve, repair, and maintain our
            products and services and to fulfill your requests; personalize, advertise, and market our products and
            services; conduct research, analytics, and data analysis; maintain our property; undertake quality and safety
            assurance measures; conduct risk and security control and monitoring; detect and prevent fraud; perform identity
            verification; perform accounting, audit, and other internal functions, such as internal investigations; to carry
            out corporate transactions,such as mergers, joint ventures or acquisitions; comply with law, legal process, and
            internal policies; maintain records; and exercise and defend legal claims.</p>
        <h4 style="color:#ffffff;">Your Rights</h4>
        Pursuant to the CCPA, upon request and upon our verification of your identity, California residents may:
        <ul>
            <li>Request access to the specific and Personal Information that we have collected about you over the past
                twelve
                months, the categories of sources of that information, our business or commercial purposes for collecting
                the
                information, and the categories of third parties with whom the information was shared;</li>
            <li>Obtain a copy of your Personal Information in a format that would permit you to transfer that Information to
                another Repository;</li>
            <li>Submit a request for deletion of Personal Information, subject to certain exceptions, including (without
                limitation) in the event that we may need to retain Personal Information to complete the transaction for
                which
                the Personal Information was collected, detect security incidents, protect against illegal activity,
                exercise
                certain rights of free speech, comply with legal obligation or for internal uses permitted by law. If your
                request is subject to any exception, we may deny your request to delete your data. Please note that you must
                verify your identity and request before further action is taken by us. To do so, we will notify you of what
                we
                require via email.</li>
            <li>To be free from unlawful discrimination for exercising your rights under the CCPA.</li>
        </ul>
        <h4 style="color:#ffffff;">Do Not Sell My Personal Information</h4>
        <p>numiner.io does not sell Personal Information in the normal course of our business, but the CCPA defines sale
            more broadly than the traditional sense of an exchange of data for money and may encompass transactions in which
            we may share your Personal Information. Accordingly you may, subject to exceptions in CCPA, request that
            numiner.io not “sell” your Personal Information to the extent that we may do so. Please be aware that certain
            sharing of your Personal Information, such as disclosures of that Information to “Service Providers” as that
            term is defined and in accordance with CCPA, or for certain business operations of numiner.io, are not
            considered “sale” of Personal Information.
            CCPA comprises provisions that explicitly prohibit us from making any adverse decisions about you or your
            account based upon your exercise of this right (“non-discrimination”).
            The CCPA permits you to request certain information regarding our disclosure of Personal Information to third
            parties for their direct marketing purposes.
            To exercise any of the above rights, you may contact us at dpo@numiner.io. Consistent with California law, you
            may designate an authorised agent to make a request on your behalf. In order to designate an authorised agent,
            please contact us via email dpo@numiner.io. Please note that any proposed appointment is subject to verification
            checks and we may deny requests from agents who are unable to prove their identity or provide proof of authority
            to act on your behalf.
            While many browsers permit you to send a signal about your Do Not Track (“DNT”) preferences, we do not respond
            to DNT signals sent from browsers.</p>
        <h4 style="color:#ffffff;">Children’s Online Privacy Protection Act</h4>
        <p>numiner.io complies with the Children’s Online Privacy Protection Act COPPA, which requires the consent of a
            parent or guardian for the collection of personally identifiable information from children under 13 years of
            age. numiner.io does not knowingly collect, use or disclose personal information from children under 13, or
            equivalent minimum age in the relevant jurisdiction, without verifiable parental consent. However, it is
            possible that we may inadvertently receive information pertaining to children under 13. If you believe that we
            have received information about your child that is under the age of 13, please do not hesitate to notify us at
            dpo@numiner.io. When we receive your notification, we will obtain your consent to retain the information or will
            delete it permanently.</p>
        <h4 style="color:#ffffff;">Vermont Privacy Rights (Applicable to Vermont Residents)Vermont Financial Privacy Act
        </h4>
        <p>The Vermont Financial Privacy Act limits what we can do with your financial information and gives you rights to
            limit our sharing of your financial information. Under the Vermont Financial Privacy Act, Vermont residents have
            the right to receive notice and opt-in to sharing non-public Personal Information with non-affiliated third
            parties. Additionally, residents must consent to us sharing information regarding credit worthiness.
            We do not share your information with affiliates and non-affiliated third parties, except for certain business
            purposes (e.g., to service your accounts), to market our products and services, as permitted by law, or with
            your consent. Additionally, we will not disclose credit information about you with our affiliates or
            non-affiliated third parties, except as required or permitted by law. You can access our Privacy Notice for
            information about our practices in accordance with the Vermont Financial Privacy Act. Please contact us to
            opt-in to, or opt-out of, sharing your non-public Personal Information.</p>
        <h4 style="color:#ffffff;">Cayman Islands Data Protection Act</h4>
        <p>The Cayman Islands Data Protection Act (as amended, the "DPA") applies to numiner.io entities that are organised
            in the Cayman Islands, including numiner.io (Cayman) Limited. Where you engage the services of such an entity,
            that entity is a data controller with respect to your Personal Data and shall process your Personal Data in
            accordance with the requirements of the DPA. Subject to complying with the DPA, the entity may also share your
            Personal Data with its affiliates, its service providers and applicable regulatory and governmental authorities
            from time to time. Any transfer of your Personal Data outside of the Cayman Islands will be carried out in
            accordance with the DPA. Individuals have certain rights under the DPA with respect to their Personal Data,
            including the right to: (a) be informed about the purposes for which your Personal Data are processed; (b)
            access your Personal Data; (c) stop direct marketing; (d) restrict the processing of your Personal Data; (e)
            have incomplete or inaccurate Personal Data corrected; (f) ask us to stop processing your Personal Data; (g) be
            informed of a Personal Data breach (unless the breach is unlikely to be prejudicial to you); (h) complain to the
            Cayman Islands Data Protection Ombudsman; and (i) require us to delete your personal data in some limited
            circumstances.</p>
    </body>

    </html>
    """
}
