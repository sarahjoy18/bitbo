<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use Carbon\Carbon;
use App\Models\TRESIDENTBASICINFO;

class ChildrenProfileController extends Controller
{
    public function index()
    {

       
    	return view('resident.childrenprofile');
    }

    public function loadchildren() 
    {
    	$display_data = COLLECT(DB::SELECT("SELECT RESIDENT_ID, CONCAT(LASTNAME,' ',FIRSTNAME,' ',MIDDLENAME) AS FULLNAME , SEX FROM t_resident_basic_info WHERE RESIDENT_ID NOT IN (SELECT RESIDENT_ID FROM t_monthers_profile) AND 
								RESIDENT_ID NOT IN (SELECT RESIDENT_ID FROM T_FATHERS_PROFILE) AND (YEAR(CURDATE())-YEAR(DATE_OF_BIRTH)) BETWEEN 1 AND 10"));
    	
    	return datatables()->of($display_data)->addIndexColumn()->make(true);
    }

    public function store()
    {
       
       
        DB::TABLE('t_children_profile')
        ->INSERT(
            [
                'RESIDENT_ID' => request('resident_id'),
                'BIRTH_ORDER' => request('brtorder'),
                'IS_REGISTERED' => request('isregistered'),
                'BORN_AT' => request('bornat'),
                'CHILDER_MOTHER_TONGUE' => request('mtongue'),
                'CHILDREN_OTHER_DIALECT' => request('m_others'),
                'CHILDREN_HEIGHT' => request('height'),
                'CHILDREN_WEIGHT' => request('weight'),
                'DOES_IT_HAVE_ECCD_CARD' => request('ceccd'),
                'DOES_IT_HAVE_MOTHER_CHILD_BOOK' => request('cmcbook'),
                'DOES_IT_HAVE_OTHERS' => request('cddothers'),
                'VACCINATION_BCG' => request('cbcg'),
                'VACCINATION_DPT' => request('cdpt'),
                'VACCINATION_ORAL_POLIO' => request('cpolio'),
                'VACCINATION_HEPA_B' => request('chepab'),
                'VACCINATION_MEASLES' => request('cmeasles'),
                'VACCINATION_OTHERS' => request('cmeaslesthers'),
                'DEFORMITY_HARE_LIP' => request('chlip'),
                'DEFORMITY_DISABLE_LEG' => request('cdleg'),
                'DEFORMITY_CROSS_EYED' => request('crossseyed'),
                'DEFORMITY_DISABLE_ARM_LEG' => request('cdarm'),
                'DEFORMITY_FINGER_TOES' => request('cftoes'),
                'DEFORMITY_DEAF' => request('cdeaf'),
                'DEFORMITY_BLIND' => request('cblind'),
                'PROBLEMS_WITH_BEHAVIOR' => request('cbehavior'),
                'PROBLEMS_WITH_SPEAKING' => request('cspeaking'),
                'PROBLEMS_WITH_HEARING' => request('chearing'),
                'PROBLEMS_WITH_VISION' => request('cvision'),
                'IS_LEFT_HANDED' => request('clefthanded'),
                'CHILDHOOD_EXP_NURSERY' => request('cnursery'),
                'CHILDHOOD_EXP_KINDERGARTEN' => request('ckinder'),
                'CHILDHOOD_EXP_PREPARATORY' => request('cprepa'),
                'LEARNS_AT_HOME_W_PARENTS' => request('cmfboth'),
                'LEARNS_AT_HOME_W_NOBODY' => request('cnbody'),
                'LEARNS_AT_HOME_W_SIBLINGS' => request('csiblings'),
                'LEARNS_AT_HOME_W_RELATIVES' => request('crela'),
                'LEARNS_AT_HOME_W_MAID' => request('cmaid'),
                'LEARNS_AT_HOME_TUTOR' => request('ctutor'),
                'LEARNS_AT_HOME_W_OTHERS' => request('l_others'),
                'INTERACTS_W_OLDER_SIBLINGS' => request('p_older'),
                'INTERACTS_W_YOUNGER_SIBLINGS' => request('p_younger'),
                'INTERACTS_W_SAME_AGE' => request('p_age'),
                'EATS_MEAL_BEFORE_SCHOOL' => request('ceatsmeals'),
                'HAS_BAON' => request('chasbaon'),
                'TRAVEL_TIME_TO_DCC' => request('ctdcc'),
                'MODE_TRANSPORTATION_TO_DCC' => request('cmdcc'),
                'TRAVEL_TIME_TO_NCDC' => request('tncdc'),
                'MODE_TRANSPORTATION_TO_NCDC' => request('cmncdc'),
                'PUBLIC_TRANSPORTATION_ID' => request('cpublic'),
                'TRANSPORTATION_FARE' => request('ctransfare'),
                'GOES_TO_SCHOOL_WITH' => request('cgowith'),
                'CHILD_DEVELOPMENT_TEACHER' => request('cdevteacher'),
                'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
                'ACTIVE_FLAG' => 1
            ]);
        echo "good";
    }
}


