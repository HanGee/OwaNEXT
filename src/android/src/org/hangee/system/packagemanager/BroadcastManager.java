package org.hangee.system.packagemanager;

import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import java.util.List;
//import java.util.HashMap;
//import java.util.ArrayList;
import android.util.Log;
import android.util.DisplayMetrics;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.ResolveInfo;
import android.content.pm.PackageInfo;
import android.content.res.Resources;
import android.os.Bundle;
import android.net.Uri;


public class BroadcastManager extends BroadcastReceiver
{
    private static final String ACTIVITY_TAG="BroadcastReceiver";

    public void onReceive(Context context,Intent intent)
    {
        String action = intent.getAction();
        String packageName = intent.getData().toString().replaceAll("package:", "");
        Log.d(BroadcastManager.ACTIVITY_TAG, "[hangee] Package Name:" + packageName);

        if (Intent.ACTION_PACKAGE_REMOVED.equals(action))
        {
            Log.d(BroadcastManager.ACTIVITY_TAG, "[hangee] Package Intent (REMOVED)");
            packageRemoved(packageName);
        }
        else if (Intent.ACTION_PACKAGE_ADDED.equals(action))
        {
            Log.d(BroadcastManager.ACTIVITY_TAG, "[hangee] Package Intent (ADDED)");

            try
            {
                final PackageManager pm = context.getPackageManager();
                ApplicationInfo packageInfo;
                packageInfo = pm.getApplicationInfo(packageName, PackageManager.GET_ACTIVITIES);
                String appName =  packageInfo.loadLabel(pm).toString();

                Intent targetIntent = new Intent(Intent.ACTION_MAIN, null);
                targetIntent.addCategory(Intent.CATEGORY_LAUNCHER);
                targetIntent.setPackage(packageName);

                for (ResolveInfo info : pm.queryIntentActivities(targetIntent, 0))
                {
                    packageAdded(appName, packageName, info.activityInfo.name.toString());
                }
            }
            catch (NameNotFoundException e)
            {
                e.printStackTrace();
            }
        }
        else
        {
            Log.d(BroadcastManager.ACTIVITY_TAG, "[hangee] Package Intent (OTHERS)");
        }

    }

    private static native void packageAdded(String appName, String packageName, String activityName);
    private static native void packageRemoved(String packageName);
}

