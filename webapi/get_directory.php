<?php

    $users = [
        [
            'number' => '1000',
            'password' => 'mypassword',
            'name' => 'User 1000',
            'myVar' => '1234',
        ],
        [
            'number' => '1001',
            'password' => 'mypassword',
            'name' => 'User 1001',
            'myVar' => '1234',
        ],
        [
            'number' => '1002',
            'password' => 'mypassword',
            'name' => 'User 1002',
            'myVar' => '1234',
        ]
    ];

?><document type="freeswitch/xml">
    <section name="directory">
        <domain name="example.com">
            <params>
                <param name="dial-string" value="{presence_id=${dialed_user}@${dialed_domain}}${sofia_contact(${dialed_user}@${dialed_domain})}"/>
            </params>
            <groups>
                <group name="default">
                    <users>
                        <?php
                            foreach($users as $user) {
                        ?>
                        <user id="<?php echo $user['number']; ?>">
                            <params>
                                <param name="password" value="<?php echo $user['password']; ?>"/>
                            </params>
                            <variables>
                                <variable name="accountcode" value="<?php echo $user['number']; ?>"/>
                                <variable name="user_context" value="public"/>
                                <variable name="effective_caller_id_name" value="<?php echo $user['name']; ?>"/>
                                <variable name="effective_caller_id_number" value="<?php echo $user['number']; ?>"/>
                                <variable name="outbound_caller_id_name" value="<?php echo $user['name']; ?>"/>
                                <variable name="outbound_caller_id_number" value="<?php echo $user['number']; ?>"/>
                                <variable name="mySuperVariable" value="<?php echo $user['myVar']; ?>" />
                            </variables>
                        </user>
                        <?php } ?>
                    </users>
                </group>
            </groups>
        </domain>
    </section>
</document>