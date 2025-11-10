<html>
<head>

<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<META HTTP-EQUIV="Expires" CONTENT="-1">


<title>IS Task Scheduler</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="webMethods.css">
<SCRIPT SRC="webMethods.js.txt"></SCRIPT>
</head>
<body>

<!-- =========================== user =========================== -->

<!-- User tasks table -->
<table width="100%">
   
    <tr>
      <td colspan=2>
	<ul>
		<li><a href="scheduler.dsp">Refresh Page</a></li>	  

        </ul>
      </td>
    </tr>

    <tr>
      <td>
        <table class="tableView" width=100% id="head" name="head">
          %invoke systemmonitoring.server.schedule:getUserTaskList%

          <tr><td class="heading" colspan=11>One-Time and Simple Interval Tasks</td></tr>
          <TR>
            <td class="oddcol">ID</td>
            <td class="oddcol wrap-text">Service</td>
            <td class="oddcol" >Description</td>
            <td class="oddcol">Queue Name</td>
            <td class="oddcol">Last Error</td>
            <td class="oddcol" nowrap>Run As User</td>
            <td class="oddcol">Target</td>
            <td class="oddcol">Interval (sec)</td>
            <td class="oddcol">Next Run (sec)</td>
            <td class="oddcol">Status</td>
            <!--<td class="oddcol">Remove</td>-->
          </tr>
          %ifvar -notempty tasks%
              <script>resetRows();</script>
          %loop tasks%
          <tr>
	          %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %value oid%</td>

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
	              	%value name%</td>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    	        	%value name%</td>
			  %endif%

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %value description%</td>

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %ifvar qName%%value qName%%else%N/A%endif%</td>

			  %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %ifvar lastError%%value lastError%%else%N/A%endif%</td>

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %value runAsUser%</td>

              %ifvar target equals('$all')%
	              %ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
	              All Servers</td>
	          %else%
	          	 %ifvar target equals('$any')%
	          	 	%ifvar parentID%%value%
		               	<script>writeTD("childrow");</script>
					%else%
	              		<script>writeTD("rowdata-l");</script>
	    		  	%endif%
	              	Any Server</td>
		         %else%
	              %ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
            	  	<script>writeTD("rowdata-l");</script>
	    		  %endif%
                  %value target%</td>
    	      	%endif%
			  %endif%

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
	          	<script>writeTD("rowdata-l");</script>
	    	  %endif%
              %ifvar interval equals(0)%once%else%%value interval decimal(-3,1)% %endif%</td>

			%ifvar schedState equals('expired')%
              		<script>writeTD("rowdata");</script>--</td>

	              	%ifvar parentID%%value%
		               	<script>writeTD("childrow");</script>
					%else%
	              		<script>writeTD("rowdata-l");</script>
	    		  	%endif%
                  	<!--<a href="javascript:redirectPage('wakeup','%value oid%')" onclick="alert('Cannot activate expired task.  The end date and time must be in the future.'); return false;">--><a><img src="icons/delete.gif" border=0></a>Expired</td>
		    %else%
              %ifvar execState equals('suspended')%
               		<script>writeTD("rowdata");</script>--</td>

	                %ifvar parentID%%value%
		               	<script>writeTD("childrow");</script>
					%else%
	              		<script>writeTD("rowdata-l");</script>
	    		  	%endif%
                    <!--<a href="javascript:redirectPage('wakeup','%value oid%')" onclick="return confirm('Are you sure you want to activate this task?');">--><a><img src="icons/delete.gif" border=0></a>Suspended</td>
              %else%
	                %ifvar %value parentID%%
		               	<script>writeTD("childrow");</script>
					%else%
	              		<script>writeTD("rowdata-l");</script>
	    		  	%endif%
                    %ifvar target equals('$all')% N/A %else%  %value msDelta decimal(-3,1)% %endif% </td>

	                %ifvar parentID%%value%
		               	<script>writeTD("childrow");</script>
					%else%
	              		<script>writeTD("rowdata-l");</script>
	    		  	%endif%
                    <!--<a href="javascript:redirectPage('suspend','%value oid%')" onclick="return confirm('Are you sure you want to suspend task?');">--><img src="images/green_check.gif" border=0>%ifvar execState equals('running')%Running%else%Active%endif%</td>
			  %endif%
            %endif%

           <!-- <script>writeTD("rowdata");</script>
                 <a class="imagelink" href="javascript:redirectPage('cancel','%value oid%')" onclick="return confirm('Are you sure you want to remove this task?');"><img src="icons/delete.gif" border=0></a></td>-->
          </tr>
		  <!--tr>
		  <td class="row" colspan=1></td>
		     <td class="row" colspan=1>%value description%</td>
			 <td class="row" colspan=6>Last Error: %ifvar lastError%%value lastError%%else%N/A%endif%</td>
		  </tr-->
              <script>swapRows();</script>
          %endloop%
          %else%
           %ifvar error%
           <tr><td class="evenrow-l" colspan=11>%value error%</td></tr>
           %else%
             <tr><td class="evenrow-l" colspan=11>No tasks are currently scheduled</td></tr>
           %endif%
          %endif%

          <tr><td class="space" colspan="11">&nbsp;</td></tr>

          <tr><td class="heading" colspan=11>Complex Repeating Tasks</td></tr>
          <TR>
            <td class="oddcol">ID</td>
            <td class="oddcol">Service</td>
            <td class="oddcol" width="100px">Description</td>
            <td class="oddcol">Queue Name</td>
            <td class="oddcol">Last Error</td>
            <td class="oddcol" nowrap>Run As User</td>
            <td class="oddcol">Target</td>
            <td class="oddcol">Interval Masks</td>
            <td class="oddcol">Next Run (sec)</td>
            <td class="oddcol">Status</td>
           <!-- <td class="oddcol">Remove</td> -->
          </tr>
          %ifvar -notempty extTasks%
              <script>resetRows();</script>
          %loop extTasks%
          <tr>
               %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %value oid%</td>

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
	              	%value name%</td>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    	        	%value name%</td>
			  %endif%

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %value description%</td>

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
			  %ifvar qName%%value qName%%else%N/A%endif%</td>

			  %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %ifvar lastError%%value lastError%%else%N/A%endif%</td>

              %ifvar parentID%%value%
               	<script>writeTD("childrow");</script>
			  %else%
              	<script>writeTD("rowdata-l");</script>
    		  %endif%
              %value runAsUser%</td>

              %ifvar target equals('$all')%
	              %ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
	              All Servers</td>
	          %else%
	          	 %ifvar target equals('$any')%
	          	 	%ifvar parentID%%value%
	               		<script>writeTD("childrow");</script>
				  	%else%
	              		<script>writeTD("rowdata-l");</script>
	    		  	%endif%
	              	Any Server</td>
		         %else%
	              %ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
    	          %value target%</td>
    	      	%endif%
			  %endif%
	      <TD class="rowdata" colspan="1" style="padding: 0px;">
								<table width="100%" class="tableInline" cellspacing="1" style="background-color: #ffffff">
									<tr>
										<script>writeTD("row");</script>
											Months
										</td>
										%ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
		    %ifvar monthMaskAlt%
		    %value monthMaskAlt%
		    %else%
		    January..December
		    %endif%
										</td>
									</tr>
									<tr>
										<script>writeTD("row");</script>
											Days
                  	</td>
										%ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
		    %ifvar dayOfMonthMaskAlt%
		    %value dayOfMonthMaskAlt%
		    %else%
		    1..31
		    %endif%
										</td>
									</tr>
									<tr>
										<script>writeTD("row");</script>
											Days&nbsp;of Week
										</td>
										%ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
		    %ifvar dayOfWeekMaskAlt%
		    %value dayOfWeekMaskAlt%
		    %else%
		    Sunday..Saturday
		    %endif%
										</td>
									</tr>
									<tr>
										<script>writeTD("row");</script>
                  		Hours
                  	</td>
										%ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
		    %ifvar hourMaskAlt%
		    %value hourMaskAlt%
		    %else%
		    0..23
		    %endif%
										</td>
									</tr>
									<tr>
										<script>writeTD("row");</script>
											Minutes
                  	</td>
										%ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
		    %ifvar minuteMaskAlt%
		    %value minuteMaskAlt%
		    %else%
		    0..59
		    %endif%
										</td>
									</tr>
								</table>
							</td>
						

			%ifvar schedState equals('expired')%
              <script>writeTD("rowdata");</script><!--<a><img src="icons/delete.gif" border=0></a>
                 Expired-->--</td>
              %ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      <script>writeTD("rowdata-l");</script>
    			  %endif%
                  <!--<a href="javascript:redirectPage('wakeup','%value oid%')" onclick="alert('Cannot activate expired task.  The end date and time must be in the future.'); return false;">--><img src="icons/delete.gif" border=0>Expired<!--</a>--></td>
		    %else%
              %ifvar execState equals('suspended')%
                <script>writeTD("rowdata");</script><!--<a><img src="icons/delete.gif" border=0></a>Suspended-->--</td>
                %ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
                    <!--<a href="javascript:redirectPage('wakeup','%value oid%')" onclick="return confirm('Are you sure you want to activate this task?');">--><img src="icons/delete.gif" border=0>Suspended<!--</a>--></td>
              %else%
                %ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
                  %ifvar target equals('$all')% N/A %else%  %value msDelta decimal(-3,1)% %endif% </td>
                %ifvar parentID%%value%
	               	<script>writeTD("childrow");</script>
				  %else%
        	      	<script>writeTD("rowdata-l");</script>
    			  %endif%
                    <!--<a href="javascript:redirectPage('suspend','%value oid%')" onclick="return confirm('Are you sure you want to suspend task?');">--><img src="images/green_check.gif" border=0>%ifvar execState equals('running')%Running%else%Active%endif%<!--</a>--></td>
			  %endif%
            %endif%

              %ifvar parentID%%value%
	               	<!--<script>writeTD("childrow");</script>-->&nbsp;
				  %else%
        	      	<!--<script>writeTD("rowdata-l");</script>-->&nbsp;
    			  %endif%
                  <!--<a class="imagelink" href="javascript:redirectPage('cancel','%value oid%')" onclick="return confirm('Are you sure you want to remove this task?');"><img src="icons/delete.gif" border=0></a></td>-->
          </tr>
              <script>swapRows();</script>
          %endloop%
          %else%
           %ifvar error%
           <tr><td class="evenrow-l" colspan=11>%value error%</td></tr>
           %else%
             <tr><td class="evenrow-l" colspan=11>No tasks are currently scheduled</td></tr>
           %endif%
          %endif%


          %endinvoke%
         <script>filterServicesInternal();</script>
         %ifvar showAll%<script>showFilterPanel()</script>%endif%
          </table>
      %endswitch%

        </td>
      </tr>
    </table>



</body>
</html>

