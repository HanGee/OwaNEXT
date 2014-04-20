package org.hangee.system.packagemanager;

import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import java.util.List;
import java.util.HashMap;
import java.util.ArrayList;
import android.util.Log;
import android.util.DisplayMetrics;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.ResolveInfo;
import android.content.pm.PackageInfo;
import android.content.res.Resources;
import android.os.Bundle;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.Bitmap;

public class PackageManager extends QtActivity
{
	private static HashMap<String, String> categoryMap;
	private static PackageManager m_instance;

	public PackageManager()
	{
		m_instance = this;

		categoryMap = new HashMap();
		categoryMap.put("LAUNCHER", Intent.CATEGORY_LAUNCHER);
	}

	public static void startApp(String pkg, String cls)
	{
		ComponentName component = new ComponentName(pkg, cls);

		// Create new intent and start activity
		Intent appIntent = new Intent();
		appIntent.setComponent(component);
		m_instance.startActivity(appIntent);
	}

	public static ArrayList getApps(String[] categories)
	{
		HashMap<String, Object> app;
		ArrayList<HashMap<String, Object>> apps = new ArrayList();
		String category;

		final Intent mainIntent = new Intent(Intent.ACTION_MAIN, null);

		// Set category filter
		for (int i = 0; i < categories.length; i++) {
			category = categoryMap.get(categories[i]);
			mainIntent.addCategory(category);
		}

		// Getting application list
		final List<ResolveInfo> pkgAppList = m_instance.getPackageManager().queryIntentActivities(mainIntent, 0);
		for (int i = 0; i < pkgAppList.size(); i++) {
			ResolveInfo info = pkgAppList.get(i);
			app = new HashMap();
			app.put("appName", info.loadLabel(m_instance.getPackageManager()).toString());
			app.put("packageName", info.activityInfo.packageName);
			app.put("activityName", info.activityInfo.name);

			apps.add(app);
		}

		return apps;
	}

	public static Bitmap getAppIcon(String pkgName)
	{
		Bitmap bitmap;
		BitmapDrawable icon;

		try {


			// Getting high resolution icon
			PackageInfo info = m_instance.getPackageManager().getPackageInfo(pkgName, 0);
			if (info.applicationInfo.icon != 0) {
				Resources res = m_instance.getPackageManager().getResourcesForApplication(pkgName);
				icon = (BitmapDrawable) res.getDrawableForDensity(info.applicationInfo.icon, DisplayMetrics.DENSITY_XHIGH);
			} else {
				// There is no high resolution icon, fallback to original one
				icon = (BitmapDrawable) m_instance.getPackageManager().getApplicationIcon(pkgName);
			}

			bitmap = icon.getBitmap();

		} catch(NameNotFoundException e) {
			bitmap = null;	
		}

		return bitmap;
	}
}
