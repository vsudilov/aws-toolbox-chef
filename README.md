aws-toolbox Cookbook
=========================


Requirements
------------
Assumed to be running in an AWS environment with a correctly defined IAM instance profile.


Attributes
----------

e.g.
#### aws-toolbox-chef::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['aws']['region']</tt></td>
    <td>String</td>
    <td>AWS region</td>
    <td><tt>us-east-1</tt></td>
  </tr>
  <tr>
    <td><tt>['aws-toolbox']['prune_unreachables']</tt></td>
    <td>Boolean</td>
    <td>When updating the DNS record, remove any A records that did not respond to `ping -c1`</td>
    <td><tt>true</tt></td>
  </tr>

  <tr>
    <td><tt>['aws-toolbox']['hosted_zone_name']</tt></td>
    <td>String</td>
    <td>Route53 Host zone name</td>
    <td><tt>unity</tt></td>
  </tr>


  <tr>
    <td><tt>['aws-toolbox']['name']</tt></td>
    <td>String</td>
    <td>DNS Record to target</td>
    <td><tt>node.hostname</tt></td>
  </tr>

</table>

Recipes
-----
#### aws-toolbox::update_dns

Append this machine's private IP to the "#{name}.#{hostedzone}." route53 internal zone A record. When compiling the set of A records, optionally prune any IP addresses that are unreachable.