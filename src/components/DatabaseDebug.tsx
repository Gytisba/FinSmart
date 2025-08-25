import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

export const DatabaseDebug: React.FC = () => {
  const [courses, setCourses] = useState<any[]>([]);
  const [modules, setModules] = useState<any[]>([]);
  const [lessons, setLessons] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchAllData();
  }, []);

  const fetchAllData = async () => {
    try {
      // Fetch courses
      const { data: coursesData, error: coursesError } = await supabase
        .from('courses')
        .select('*');
      
      if (coursesError) {
        console.error('Courses error:', coursesError);
      } else {
        console.log('Courses found:', coursesData);
        setCourses(coursesData || []);
      }

      // Fetch modules
      const { data: modulesData, error: modulesError } = await supabase
        .from('course_modules')
        .select('*');
      
      if (modulesError) {
        console.error('Modules error:', modulesError);
      } else {
        console.log('Modules found:', modulesData);
        setModules(modulesData || []);
      }

      // Fetch lessons
      const { data: lessonsData, error: lessonsError } = await supabase
        .from('course_lessons')
        .select('*');
      
      if (lessonsError) {
        console.error('Lessons error:', lessonsError);
      } else {
        console.log('Lessons found:', lessonsData);
        setLessons(lessonsData || []);
      }
    } catch (err) {
      console.error('Database debug error:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div>Loading database debug...</div>;
  }

  return (
    <div className="p-4 bg-gray-100 rounded-lg">
      <h3 className="font-bold mb-4">Database Debug Info</h3>
      
      <div className="mb-4">
        <h4 className="font-semibold">Courses ({courses.length}):</h4>
        <pre className="text-xs bg-white p-2 rounded overflow-auto">
          {JSON.stringify(courses, null, 2)}
        </pre>
      </div>

      <div className="mb-4">
        <h4 className="font-semibold">Modules ({modules.length}):</h4>
        <pre className="text-xs bg-white p-2 rounded overflow-auto">
          {JSON.stringify(modules, null, 2)}
        </pre>
      </div>

      <div className="mb-4">
        <h4 className="font-semibold">Lessons ({lessons.length}):</h4>
        <pre className="text-xs bg-white p-2 rounded overflow-auto">
          {JSON.stringify(lessons, null, 2)}
        </pre>
      </div>

      <button 
        onClick={fetchAllData}
        className="bg-blue-500 text-white px-4 py-2 rounded"
      >
        Refresh Data
      </button>
    </div>
  );
};