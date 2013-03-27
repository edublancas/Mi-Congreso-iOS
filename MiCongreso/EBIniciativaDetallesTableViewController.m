//
//  EBIniciativaDetallesTableViewController.m
//  MiCongreso
//
//  Created by Edu on 17/03/13.
//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "EBIniciativaDetallesTableViewController.h"

#define kFontSize 15.0f
#define kTopMargin 10.0f
#define kBottomMargin 10.0f

@interface EBIniciativaDetallesTableViewController ()

@end

@implementation EBIniciativaDetallesTableViewController

@synthesize iniciativa;


-(void)didUpdateDetails{
    NSLog(@"Did update %d", iniciativa.localTotalVotos);
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Detalles";
}


-(void)viewWillAppear:(BOOL)animated{
    iniciativa.delegate = self;
    [super viewWillAppear:animated];

}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:ACAccountStoreDidChangeNotification];
    iniciativa.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 4:
            return [iniciativa.recursosAdicionales count];
        case 5:
            if (iniciativa.plenoAbstenciones && iniciativa.plenoAFavor && iniciativa.plenoEnContra) {
                return 3;
            }else{
                return 1;
            }
        case 6:
            return 3;
        case 7:
            if(!didVote)
                return 2;
            else
                return 1;
        default:
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Fecha";
        case 1:
            return @"Propuesta por";
        case 2:
            return @"Descripción";
        case 3:
            return @"Estado de la iniciativa";
        case 4:
            return @"Recursos adicionales";
        case 5:
            return @"Votación oficial";
        case 6:
            return @"Votación en Curul501";
        case 7:
            return @"Vota la iniciativa en Curul501";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = iniciativa.fecha;
            break;
        case 1:
            if (iniciativa.nombreCongresista)
                cell.textLabel.text = iniciativa.nombreCongresista;
            else
                cell.textLabel.text = @"Información no disponible";
            break;
        case 2:
            cell.textLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
            cell.textLabel.numberOfLines = 10;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = iniciativa.descripcion;
            break;
        case 3:
            cell.textLabel.text = iniciativa.estado;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 4:
            cell.textLabel.text = [[iniciativa.recursosAdicionales objectAtIndex:indexPath.row]objectForKey:@"nombre"];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
            cell.textLabel.numberOfLines = 10;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 5:
            if (iniciativa.plenoAbstenciones && iniciativa.plenoAFavor && iniciativa.plenoEnContra) {
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"Votos a favor: %d", iniciativa.plenoAFavor];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"Votos en contra: %d", iniciativa.plenoEnContra];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"Abstenciones: %d", iniciativa.plenoAbstenciones];
                        break;
                    default:
                        break;
                }
            }else{
                cell.textLabel.text = @"Esta iniciativa no ha sido votada";
            }
            
            break;
        case 6:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"Porcentaje a favor: %d%%", iniciativa.localAFavorPorcentaje];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"Porcentaje en contra: %d%%", iniciativa.localEnContraPorcentaje];
                    break;
                case 2:                
                    cell.textLabel.text = [NSString stringWithFormat:@"Número de votos: %d", iniciativa.localTotalVotos];
                    break;
                default:
                    break;
            }
            break;
        case 7:
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            if (!didVote) {
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"Votar a favor";
                        break;
                    case 1:
                        cell.textLabel.text = @"Votar a en contra";
                    default:
                        break;
                }
            }else{
                cell.textLabel.text = @"Compartir mi voto";
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section==2) {
        CGSize maxSize = CGSizeMake(280.0f, 200.0f);
        CGSize size = [iniciativa.descripcion sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height+kTopMargin+kBottomMargin;
        
    }else if(indexPath.section==4){
        CGSize maxSize = CGSizeMake(250.0f, 200.0f);
        CGSize size = [[[iniciativa.recursosAdicionales objectAtIndex:indexPath.row]objectForKey:@"nombre"] sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height+kTopMargin+kBottomMargin;
        
    }else{
        return 46.0f;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==7) {
        if (!didVote) {
            if (indexPath.row==0) {
                //Vote up
                [iniciativa voteUp];
                didUpVote = YES;
            }else{
                //Vote down
                [iniciativa voteDown];
                didUpVote = NO;
            }
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"¡Gracias!"
                                  message:@"Tu voto ha sido registrado"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            alert.tag = 0;
            
            [alert show];
            didVote = YES;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Comparte tu voto"
                                  message:@"¿Dónde deseas compartir tu voto?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancelar"
                                  otherButtonTitles:@"Twitter",
                                  @"Facebook", nil];
            
            alert.tag = 1;
            
            [alert show];
        }
        
    }else if(indexPath.section==4){
        //Abrir Safari
        NSURL *url = [NSURL URLWithString:[[iniciativa.recursosAdicionales objectAtIndex:indexPath.row]objectForKey:@"url"]];
        [[UIApplication sharedApplication] openURL:url];
    }else if(indexPath.section==3){
        EBEstadoIniciativaViewController *controller = [[EBEstadoIniciativaViewController alloc]initWithStyle:UITableViewStyleGrouped];
        controller.estado = iniciativa.estado;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            //Twitter
            [self postVoteTo:SLServiceTypeTwitter];
        }else if(buttonIndex==2){
            //Facebook
            [self postVoteTo:SLServiceTypeFacebook];
        }
    }
    
}


-(void)postVoteTo:(NSString *)socialNetwork{
    
    if ([SLComposeViewController isAvailableForServiceType:socialNetwork]) {
        
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:socialNetwork];
        
        NSString *text;
        if (didUpVote) {
            text = @"He votado a favor de una iniciativa en Curul501";
        }else{
            text = @"He votado en contra de una iniciativa en Curul501";
        }
        
        [composeViewController setInitialText:text];
        
        NSString *urlString = [NSString stringWithFormat:@"http://curul501.org/iniciativas/%@", iniciativa.identificadorDeIniciativa];
        [composeViewController addURL:[NSURL URLWithString:urlString]];
        
        SLComposeViewControllerCompletionHandler handler = ^(SLComposeViewControllerResult result){
            [composeViewController dismissViewControllerAnimated:YES completion:Nil];
        };
        
        [composeViewController setCompletionHandler:handler];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Aviso"
                              message:@"Debes configurar una cuenta primero"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
    }
}

@end
